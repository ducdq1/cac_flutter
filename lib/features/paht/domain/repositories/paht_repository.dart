import 'package:citizen_app/features/paht/data/models/ckbg_detail_model.dart';
import 'package:citizen_app/features/paht/data/models/product_model.dart';
import 'package:citizen_app/features/paht/data/models/quotation_detail_model.dart';
import 'package:citizen_app/features/paht/data/models/search_product_model.dart';
import 'package:citizen_app/features/paht/domain/entities/ckbg_entity.dart';
import 'package:citizen_app/features/paht/domain/entities/comment_entity.dart';
import 'package:citizen_app/features/paht/domain/entities/entities.dart';
import 'package:citizen_app/features/paht/domain/usecases/create_ckbg.dart';
import 'package:citizen_app/features/paht/domain/usecases/usecases.dart';
import 'package:citizen_app/features/paht/presentation/pages/paht_detail_page.dart';

abstract class PahtRepository {
  Future<List<CKBGEntity>> getListCKBG(PahtParams parram);

  Future<List<PahtEntity>> getListPublicPaht(PahtParams parram);

  Future<List<PahtEntity>> getListPersonalPaht(
      PahtParams parram);

  Future<List<StatusEntity>> getListStatusPublic();

  Future<List<StatusEntity>> getListStatusPersonal();

  Future<SearchProductModel> searchProduct(SearchProductParam param);

  Future<SearchProductModel> getDetailedPaht(SearchProductParam param);

  Future<String> createIssuePaht(QuotationParams issueParams);

  Future<String> createCKBG(CreateCKBGParams issueParams);

  Future<bool> deleteCKBG(int id);

  Future<List<CKBGDetailModel>> getListCKBGDetail(int id);

  Future<List<QuotationDetailModel>> getListQuotationDetail(int id);

  Future<bool> updatePaht(UpdatedParams updatedParams);

  Future<bool> deletePaht({String id});

  Future<bool> updateProcessor(String workerId,String processor);

  Future<void> updateLastLogin(String workerId);
}
