import 'dart:convert';

import 'package:citizen_app/core/network/network_info.dart';
import 'package:citizen_app/features/paht/data/data_sources/data_sources.dart';
import 'package:citizen_app/features/paht/data/models/ckbg_detail_model.dart';
import 'package:citizen_app/features/paht/data/models/ckbg_model.dart';
import 'package:citizen_app/features/paht/data/models/models.dart';
import 'package:citizen_app/features/paht/data/models/product_model.dart';
import 'package:citizen_app/features/paht/data/models/quotation_detail_model.dart';
import 'package:citizen_app/features/paht/data/models/search_product_model.dart';
import 'package:citizen_app/features/paht/domain/entities/ckbg_entity.dart';
import 'package:citizen_app/features/paht/domain/entities/comment_entity.dart';
import 'package:citizen_app/features/paht/domain/repositories/repositories.dart';
import 'package:citizen_app/features/paht/domain/usecases/create_ckbg.dart';
import 'package:citizen_app/features/paht/domain/usecases/usecases.dart';
import 'package:citizen_app/features/paht/presentation/pages/paht_detail_page.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:citizen_app/features/paht/data/models/paht_model.dart';
import 'package:citizen_app/features/paht/domain/usecases/usecases.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

typedef Future<List<PahtModel>> _PublicOrPersonalChooser();
typedef Future<List<StatusModel>> _StatusPublicOrStatusPersonalChooser();

class PahtRepositoryImpl implements PahtRepository {
  final PahtRemoteDataSource remoteDataSource;
  final PahtLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  PahtRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  @override
  Future<List<PahtModel>> getListPersonalPaht(PahtParams parram) async {
    return await _getListPaht(() {
      return remoteDataSource.fetchListPersonalPaht(parram);
    });
  }

  @override
  Future<List<PahtModel>> getListPublicPaht(PahtParams parram) async {
    return await _getListPaht(() {
      return remoteDataSource.fetchListPublicPaht(parram);
    });
  }

  Future<List<PahtModel>> _getListPaht(
    _PublicOrPersonalChooser getPublicOrPersonal,
  ) async {
    try {
      final remotePaht = await getPublicOrPersonal();
      localDataSource.cachePaht(remotePaht);
      return remotePaht;
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<List<StatusModel>> getListStatusPersonal() async {
    return await _getListStatus(() {
      return remoteDataSource.fetchListStatusPersonal();
    });
  }

  @override
  Future<List<StatusModel>> getListStatusPublic() async {
    return await _getListStatus(() {
      return remoteDataSource.fetchListStatusPublic();
    });
  }

  Future<List<StatusModel>> _getListStatus(
      _StatusPublicOrStatusPersonalChooser
          statusPublicOrStatusPersonalChooser) async {
    try {
      final remoteStatusPaht = await statusPublicOrStatusPersonalChooser();
      localDataSource.cacheStatusPaht(remoteStatusPaht);
      return remoteStatusPaht;
    } catch (error) {
      throw Exception(error);
    }
  }

  @override
  Future<SearchProductModel> getDetailedPaht(SearchProductParam param) async {
    try {
      final remoteCategoriesPaht =
          await remoteDataSource.fetchDetailedPaht(param);
      // localDataSource.cacheCategoriesPaht(remoteCategoriesPaht);
      return remoteCategoriesPaht;
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<String> createIssuePaht(QuotationParams issueParams) async {
    try {
      final remoteCreateIssuePaht =
          await remoteDataSource.createIssuePaht(issueParams);
      // localDataSource.cacheCategoriesPaht(remoteCategoriesPaht);
      return remoteCreateIssuePaht;
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<bool> deletePaht({String id}) async {
    try {
      final result = await remoteDataSource.deletePaht(id: id);
      return result;
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<bool> updatePaht(UpdatedParams updatedParams) async {
    try {
      final result = await remoteDataSource.updatePaht(updatedParams);
      return result;
    } catch (error) {
      throw Exception(error);
    }
  }

  @override
  Future<List<QuotationDetailModel>> getListQuotationDetail(int id) async {
    try {
      final remoteCreateIssuePaht =
          await remoteDataSource.getListQuotationDetail(id);
      return remoteCreateIssuePaht;
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<SearchProductModel> searchProduct(SearchProductParam param) async {
    try {
      final remoteCreateIssuePaht = await remoteDataSource.searchProduct(param);
      return remoteCreateIssuePaht;
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<bool> updateProcessor(String workerId, String processor) async {
    try {
      final remoteCreateIssuePaht =
          await remoteDataSource.updateProcessor(workerId, processor);
      return remoteCreateIssuePaht;
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<bool> updateLastLogin(String workerId) async {
    try {
      return await remoteDataSource.updateWorkerLastLogin(workerId);
    } catch (error) {
    }
  }

  @override
  Future<CKBGModel> createCKBG(CreateCKBGParams issueParams) async {
    try {
      return await remoteDataSource.createCKBG(issueParams);
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<List<CKBGDetailModel>> getListCKBGDetail(int id) async {
    try {
      return await remoteDataSource.getListCKBGDetail(id);
    } catch (error) {
      throw error;
    }
  }


  @override
  Future<bool> deleteCKBG(int id) async {
    try {
      return await remoteDataSource.deleteCKBG(id);
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<List<CKBGEntity>> getListCKBG(PahtParams parram) async{
    try {
      return await remoteDataSource.fetchListCKBG(parram);
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<bool> checkUser(String userName, String pw) async{
    try {
      return await remoteDataSource.checkUser(userName,pw);
    } catch (error) {
      throw error;
    }
  }
}
