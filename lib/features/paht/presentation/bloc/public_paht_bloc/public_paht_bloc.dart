import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:citizen_app/features/customer/presentation/bloc/productCategory/product_category_bloc.dart';
import 'package:citizen_app/features/paht/data/models/ckbg_model.dart';
import 'package:citizen_app/features/paht/data/models/paht_model.dart';
import 'package:citizen_app/features/paht/data/models/product_model.dart';
import 'package:citizen_app/features/paht/data/models/search_product_model.dart';
import 'package:citizen_app/features/paht/data/repositories/paht_repository_impl.dart';
import 'package:citizen_app/features/paht/domain/usecases/search_product.dart';
import 'package:citizen_app/features/paht/domain/usecases/usecases.dart';
import 'package:citizen_app/injection_container.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:citizen_app/features/paht/presentation/pages/paht_detail_page.dart';

part 'public_paht_event.dart';

part 'public_paht_state.dart';

class PublicPahtBloc extends Bloc<PublicPahtEvent, PublicPahtState> {
  final GetListPublicPaht getListPublicPaht;
  final SearchProduct searchProduct;
  final DeletePaht deletePaht;

  PublicPahtBloc(
      {@required this.getListPublicPaht,
      @required this.deletePaht,
      @required this.searchProduct})
      : super(PublicPahtInitial());

  bool _hasReachedMax(PublicPahtState state) =>
      state is PublicPahtSuccess && state.hasReachedMax;

  bool _hasReachedMaxCKBG(PublicPahtState state) =>
      state is ListCKBGSuccess && state.hasReachedMax;

  @override
  Stream<PublicPahtState> mapEventToState(
    PublicPahtEvent event,
  ) async* {
    final currentState = state;
    final prefs = singleton<SharedPreferences>();
    final userName = prefs.get('token').toString();

    if (event is ListProductFetchingEvent) {

      try {
        if (event.offset == 0 || currentState is SearchProducttFailure ||
          currentState is PublicPahtInitial ) {
          yield PublicPahtLoading();
        await Future.delayed(Duration(milliseconds: 1000));
        SearchProductModel listPublicPaht = await searchProduct(
            SearchProductParam(
                productCode: event.search,
                limit: event.limit,
                offset: 0,
                type: event.type,
                isAgent: event.isAgent,
                code: event.code,
                searchType: event.selectType,
                isGetPromotionProduct: event.isGetPromotionProduct));
        yield SearchProductSuccess(
          lstProduct: listPublicPaht.lstProduct,
          offset: 0,
          hasReachedMax: listPublicPaht.lstProduct.length  < event.limit ? true : false,
        );
        return;
      } else if (currentState is SearchProductSuccess &&
            !currentState.hasReachedMax) {
        //load more
          yield SearchProductLoadMore(
            lstProduct: currentState.lstProduct,
            offset: currentState.offset,
            hasReachedMax: false,
          );
        int nextOffset = currentState.offset + 1;
        await Future.delayed(Duration(milliseconds: 1000));
        SearchProductModel listPublicPaht = await searchProduct(
            SearchProductParam(
                productCode: event.search,
                limit: event.limit,
                offset: nextOffset,
                type: event.type,
                isAgent: event.isAgent,
                code: event.code,
                searchType: event.selectType,
                isGetPromotionProduct: event.isGetPromotionProduct));

          yield listPublicPaht.lstProduct.isEmpty
              ? currentState.copyWith(
                  hasReachedMax: true, offset: currentState.offset)
              : SearchProductSuccess(
            lstProduct: currentState.lstProduct + listPublicPaht.lstProduct ,
                  offset: nextOffset,
                  hasReachedMax: listPublicPaht.lstProduct.length  < event.limit ? true : false,
              );
        } else if (currentState is SearchProductSuccess &&
              currentState.hasReachedMax) {
            yield SearchProductSuccess(
              lstProduct: currentState.lstProduct,
              offset: currentState.offset,
              hasReachedMax:true,
            );
          return;
        }
      } catch (error) {
        if(currentState is SearchProductSuccess){
          yield SearchProductSuccess(
            lstProduct: currentState.lstProduct,
            offset: currentState.offset,
            hasReachedMax: false,
          );

        }else {
          yield SearchProducttFailure(error: error.message);
        }
      }
      return;
    }

    if (event is SearchPublicButtonPressedEvent) {
      yield PublicPahtLoading();

      List<PahtModel> listPublicPaht = await getListPublicPaht(PahtParams(
          limit: 10,
          offset: 0,
          status: 0,
          userName: userName,
          search: event.search,
          isApproveAble: event.isApproveAble));
      yield PublicPahtSuccess(
          paht: listPublicPaht, offset: 0, hasReachedMax: true);
      return;
    }

    if (event is ListPublicPahtFetchedEvent) {
      if (event.error != null) {
        yield PublicPahtFailure(error: event.error);
        return;
      }

      yield PublicPahtSuccess(
          paht: event.paht,
          offset: event.offset,
          hasReachedMax: event.paht.length < 10 ? true : false,
          error: event.error);
      return;
    }

    if (event is ListPublicPahtFetchingEvent) {
      if (currentState is PublicPahtFailure ||
          currentState is PublicPahtSuccess && (currentState.paht == null)) {
        yield PublicPahtLoading();
      }

      try {
        if (currentState is PublicPahtFailure ||
            currentState is DeletePersonalPahtFailure ||
            currentState is PublicPahtInitial &&
                !_hasReachedMax(currentState)) {
          await Future.delayed(Duration(milliseconds: 500));
          getListPublicPaht(PahtParams(
                  limit: 10,
                  offset: 0,
                  status: 0,
                  userName: userName,
                  isApproveAble: event.isApproveAble,
                  isSaled: event.isSaled))
              .then((value) {
            add(ListPublicPahtFetchedEvent(offset: 0, paht: value));
          }).catchError((err) {
            add(ListPublicPahtFetchedEvent(
                offset: 0, paht: [], error: err.message));
          });
        } else if (currentState is PublicPahtSuccess &&
            !_hasReachedMax(currentState)) {
          int nextOffset = currentState.offset + 1;
          List<PahtModel> listPublicPaht = await getListPublicPaht(PahtParams(
              limit: 10,
              offset: nextOffset,
              status: 0,
              userName: userName,
              isApproveAble: event.isApproveAble,
              isSaled: event.isSaled));

          yield listPublicPaht.isEmpty
              ? currentState.copyWith(
                  hasReachedMax: true, offset: currentState.offset)
              : PublicPahtSuccess(
                  paht: currentState.paht + listPublicPaht,
                  offset: nextOffset,
                  hasReachedMax:
                      listPublicPaht.isNotEmpty && listPublicPaht.length == 10
                          ? false
                          : true,
                );
        } else {
          if (currentState is PublicPahtSuccess &&
              _hasReachedMax(currentState)) {
            yield PublicPahtSuccess(
              paht: currentState.paht,
              offset: currentState.offset,
              hasReachedMax: true,
            );
            return;
          }
        }
      } catch (error) {
        if (currentState is PublicPahtSuccess) {
          yield PublicPahtSuccess(
            paht: currentState.paht,
            offset: currentState.offset,
            hasReachedMax: true,
          );
        } else if (currentState is PublicPahtRefreshSuccess) {
          yield PublicPahtSuccess(
            paht: currentState.paht,
            offset: currentState.offset,
            hasReachedMax: true,
          );
        } else
          yield PublicPahtFailure(error: error.message);
      }
    }


    if (event is PublicPahtRefreshRequestedEvent) {
      if (event.type == 1) {
        yield PublicPahtLoading();
      }

      try {
        List<PahtModel> listPublicPaht = await getListPublicPaht(PahtParams(
            limit: 10,
            offset: 0,
            status: 0,
            userName: userName,
            isApproveAble: event.isApproveAble,
            isSaled: event.isSaled));

        yield PublicPahtRefreshSuccess(
            paht: listPublicPaht,
            offset: 0,
            hasReachedMax: listPublicPaht.length < 10 ? true : false);

        yield PublicPahtSuccess(
            paht: listPublicPaht,
            offset: 0,
            hasReachedMax: listPublicPaht.length < 10 ? true : false);
        return;
      } catch (error) {
        if (currentState is PublicPahtSuccess) {
          yield PublicPahtSuccess(
              paht: currentState.paht,
              offset: currentState.offset,
              hasReachedMax: true,
              error: error.message);
        } else if (currentState is PublicPahtRefreshSuccess) {
          yield PublicPahtSuccess(
              paht: currentState.paht,
              offset: currentState.offset,
              hasReachedMax: true,
              error: error.message);
        } else {
          print(error);
          yield PublicPahtFailure(error: error.message);
        }
      }
    }

    if (event is DeleteButtonEvent) {
      try {
        await deletePaht(event.id);
        yield DeletePersonalPahtSuccess();
        List<PahtModel> results = await getListPublicPaht(
            PahtParams(offset: 0, limit: 10, status: 0, userName: userName));

        yield PublicPahtSuccess(
            offset: 0,
            paht: results,
            hasReachedMax: results.length < 10 ? true : false);
      } catch (error) {
        yield DeletePersonalPahtFailure(error: error.message);
      }
    }

    if (event is ReloadListEvent) {
      try {
        yield DeletePersonalPahtSuccess();
        List<PahtModel> results = await getListPublicPaht(PahtParams(
            offset: 0,
            limit: 10,
            status: 0,
            userName: userName,
            isApproveAble: event.isApproveAble,
            isSaled: event.isSaled));

        yield PublicPahtSuccess(
            offset: 0,
            paht: results,
            hasReachedMax: results.length < 10 ? true : false);
      } catch (error) {
        yield DeletePersonalPahtFailure(error: error);
      }
    }


    if (event is ListCKBGFetchedEvent) {
      if (event.error != null) {
        yield PublicPahtFailure(error: event.error);
        return;
      }

      yield ListCKBGSuccess(
          paht: event.paht,
          offset: event.offset,
          hasReachedMax: event.paht.length < 100 ? true : false,
          error: event.error);
      return;
    }

    if (event is ListCKBGFetchingEvent) {
      if (currentState is PublicPahtFailure ||
          currentState is ListCKBGSuccess && (currentState.paht == null)) {
        yield PublicPahtLoading();
      }

      try {
        PahtRepositoryImpl repo = PahtRepositoryImpl(localDataSource: singleton(),
          networkInfo: singleton(),
          remoteDataSource: singleton(),);
        if (currentState is PublicPahtFailure ||
            currentState is DeletePersonalPahtFailure ||
            currentState is PublicPahtInitial &&
                !_hasReachedMaxCKBG(currentState)) {
          await Future.delayed(Duration(milliseconds: 200));

          repo.getListCKBG(PahtParams(
              limit: 100,
              offset: 0,
              status: 0,
              userName: userName, ))
              .then((value) {
            add(ListCKBGFetchedEvent(offset: 0, paht: value));
          }).catchError((err) {
            add(ListCKBGFetchedEvent(
                offset: 0, paht: [], error: err.message));
          });
        } else if (currentState is ListCKBGSuccess  &&
            !_hasReachedMaxCKBG(currentState)) {
          int nextOffset = currentState.offset + 1;
          List<CKBGModel> listPublicPaht = await repo.getListCKBG(PahtParams(
              limit: 100,
              offset: nextOffset,
              status: 0,
              userName: userName));

          yield listPublicPaht.isEmpty
              ? currentState.copyWith(
              hasReachedMax: true, offset: currentState.offset)
              : ListCKBGSuccess(
            paht: currentState.paht + listPublicPaht,
            offset: nextOffset,
            hasReachedMax:
            listPublicPaht.isNotEmpty && listPublicPaht.length == 100
                ? false
                : true,
          );
        } else {
          if (currentState is ListCKBGSuccess &&
              _hasReachedMaxCKBG(currentState)) {
            yield ListCKBGSuccess(
              paht: currentState.paht,
              offset: currentState.offset,
              hasReachedMax: true,
            );
            return;
          }
        }
      } catch (error) {
        if (currentState is ListCKBGSuccess) {
          yield ListCKBGSuccess(
            paht: currentState.paht,
            offset: currentState.offset,
            hasReachedMax: true,
          );
        } else if (currentState is CKBGRefreshSuccess) {
          yield ListCKBGSuccess(
            paht: currentState.paht,
            offset: currentState.offset,
            hasReachedMax: true,
          );
        } else
          yield PublicPahtFailure(error: error.message);
      }
    }

    if (event is CKBGRefreshRequestedEvent) {
      if (event.type == 1) {
        yield PublicPahtLoading();
      }

      PahtRepositoryImpl repo = PahtRepositoryImpl(localDataSource: singleton(),
        networkInfo: singleton(),
        remoteDataSource: singleton(),);

      try {
        List<CKBGModel> listPublicPaht = await repo.getListCKBG(PahtParams(
            limit: 100,
            offset: 0,
            status: 0,
            userName: userName));

        yield CKBGRefreshSuccess(
            paht: listPublicPaht,
            offset: 0,
            hasReachedMax: listPublicPaht.length < 100 ? true : false);

        yield ListCKBGSuccess(
            paht: listPublicPaht,
            offset: 0,
            hasReachedMax: listPublicPaht.length < 100 ? true : false);
        return;
      } catch (error) {
        if (currentState is ListCKBGSuccess) {
          yield ListCKBGSuccess(
              paht: currentState.paht,
              offset: currentState.offset,
              hasReachedMax: true,
              error: error.message);
        } else if (currentState is CKBGRefreshSuccess) {
          yield ListCKBGSuccess(
              paht: currentState.paht,
              offset: currentState.offset,
              hasReachedMax: true,
              error: error.message);
        } else {
          print(error);
          yield PublicPahtFailure(error: error.message);
        }
      }
    }

    if (event is DeleteCKBGEvent) {
      try {
        PahtRepositoryImpl repo = PahtRepositoryImpl(localDataSource: singleton(),
          networkInfo: singleton(),
          remoteDataSource: singleton(),);
        await repo.deleteCKBG(event.id);
        yield DeletePersonalPahtSuccess();
        List<CKBGModel> results = await repo.getListCKBG(
            PahtParams(offset: 0, limit: 100, status: 0, userName: userName));

        yield ListCKBGSuccess(
            offset: 0,
            paht: results,
            hasReachedMax: results.length < 100 ? true : false);
      } catch (error) {
        yield DeletePersonalPahtFailure(error: error.message);
      }
    }

  }
}
