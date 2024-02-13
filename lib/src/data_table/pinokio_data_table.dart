import 'package:data_table_2/data_table_2.dart';

import 'package:flutter/material.dart';
import 'package:flutter_pinokio_library/flutter_pinokio_library.dart';
import 'package:flutter_svg/flutter_svg.dart';

// PinokioDataColumn을 정의할 때, 해당 Column에 들어가는 Data들이 어떤 형태인지를 정의합니다.
// 기본값은 clipboardtext로 설정되어 있습니다.
// [clipboardtext] : 클릭하면 클립보드에 복사되는 텍스트 형태
// [clipboarddate] : 클릭하면 클립보드에 복사되는 날짜 형태. DateTime 형태로 들어올 시 substring(0, 10)으로 변환하여 사용합니다.
//                   단, 유니패스에 있는 날짜데이터(yyyyMMdd)처럼  length가 10보다 작을 경우에는 그대로 사용합니다.
// [checkbutton] : 선택 가능한 테이블에서 제일 왼쪽에 사용되는 체크박스 아이콘 (현재 미구현)
// [detailbutton] : search_product_detail_page로 이동하는 버튼 아이콘. 해당 BL번호에 메모가 있는 경우, 메모 아이콘을 표시합니다.
// [bltext] : 클릭하면 클립보드에 복사되는 텍스트 형태. 기한임박 아이콘이 포함되어 있어 clipboardtext와 별도로 정의합니다.
// [picture] : 화물에 등록된 사진을 표시하는 위젯입니다.
// [divider] : 고정된 컬럼과 나머지 컬럼을 구분하는 위젯입니다. 컬럼 고정시에만 사용합니다.
//             실제 PaginationDataTable2를 그릴 때 별도로 삽입합니다.

enum ColumnType {
  clipboardtext,
  clipboarddate,
  checkbutton,
  detailbutton,
  bltext,
  picture,
  divider
}

typedef DataColumnBuilder = Widget Function(
    BuildContext context, Map<String, dynamic> data, String key);

DataColumnBuilder defaultBuilder =
    (BuildContext context, dynamic data, String field) {
  if (field == 'photo_count') {
    return Center(
      child: ClipboardText(text: data['picture_id_list'].length.toString()),
    );
  }
  return Center(
    child:
        ClipboardText(text: data[field] == null ? '-' : data[field].toString()),
  );
};

// 각 컬럼에 들어갈 데이터의 형태를 정의합니다.
// ColumnType에 따라서 자동으로 builder는 정의됩니다.

// [checkButtonBuilder] : 선택 가능한 테이블에서 제일 왼쪽에 사용되는 체크박스 아이콘 (현재 미구현)
// [detailButtonBuilder] : search_product_detail_page로 이동하는 버튼 아이콘. 해당 BL번호에 메모가 있는 경우, 메모 아이콘을 표시합니다.
// [blTextBuilder] : 클릭하면 클립보드에 복사되는 텍스트 형태. 기한임박 아이콘이 포함되어 있어 clipboardtext와 별도로 정의합니다.
// [clipBoardTextBuilder] : 클릭하면 클립보드에 복사되는 텍스트 형태
// [clipBoardDateBuilder] : 클릭하면 클립보드에 복사되는 날짜 형태. DateTime 형태로 들어올 시 substring(0, 10)으로 변환하여 사용합니다.
//                          단, 유니패스에 있는 날짜데이터(yyyyMMdd)처럼  length가 10보다 작을 경우에는 그대로 사용합니다.
// [pictureBuilder] : 화물에 등록된 사진을 표시하는 위젯입니다.
// [dividerBuilder] : 고정된 컬럼과 나머지 컬럼을 구분하는 위젯입니다. 실제 PaginationDataTable2를 그릴 때 별도로 삽입합니다.

Widget checkButtonBuilder(data, field) {
  return Center(
    child: Container(),
    // TODO : 체크박스 아이콘 구현
    // onSelectedChanged에 따라서 아래 주석처리 된 아이콘을 보여주는 코드를 작성하면 됩니다.
    // 주의점 : TIPA 웹페이지에서 해당 체크버튼을 사용할 때, 페이지 별로 아이콘을 보여주는 기준이 다르기 때문에 해당 상황을 잘 고려해서 구현해야 합니다.
    // ex) 감정방식 변경 메뉴 : 제한 없음
    //     감정요청 : 최초 선택한 화물과 동일한 권리자만 selectable, 나머지는 unselectable
    //     세관통보 : 최초 선택한 화물과 customs_id가 같으면 selectable, 나머지는 unselectable
    //     등등...
    // 해당 로직은 기존 소스코드의 각 페이지(선택 가능한)별 widget - XXX_table_source.dart의 getRow의 cells의 첫 부분에서 확인 가능합니다.
    // child: state.selectedList.isEmpty
    //     ? SvgPicture.asset("images/icon_checkbox_selectable.svg")
    //     : state.selectedList.contains(data['freight_id'])
    //         ? SvgPicture.asset("images/icon_checkbox_selected.svg")
    //         : SvgPicture.asset("images/icon_checkbox_selectable.svg"),
  );
}

Widget detailButtonBuilder(data, field, context, onTap) {
  return Center(
    child: SizedBox(
      width: 30,
      height: 30,
      child: data['memo'] != ''
          ? Tooltip(
              message: '해당 화물에\n메모가 있습니다.',
              child: InkWell(
                  onTap: onTap,
                  // onTap: () {
                  //   Navigator.of(context).push(SearchProductDetailPage.route(
                  //       data['freight_id'], data['bl'].toString()));
                  // },
                  child: SvgPicture.asset(
                    'images/icon_detail_with_memo.svg',
                    package: 'pinokio_library',
                  )),
            )
          : InkWell(
              onTap: onTap,
              // onTap: () {
              //   Navigator.of(context).push(SearchProductDetailPage.route(
              //       data['freight_id'], data['bl'].toString()));
              // },
              child: SvgPicture.asset(
                'images/icon_detail.svg',
                package: 'pinokio_library',
              )),
    ),
  );
}

sealed class MyWidget extends StatelessWidget {
  const MyWidget({super.key, required this.data, required this.field});

  final Map<String, dynamic> data;
  final String field;
}

class DetailButton extends MyWidget {
  const DetailButton(
      {super.key,
      required super.data,
      required super.field,
      required this.onTap});

  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 30,
        height: 30,
        child: data['memo'] != ''
            ? Tooltip(
                message: '해당 화물에\n메모가 있습니다.',
                child: InkWell(
                    onTap: onTap,
                    // TODO: 버튼 클릭 시 해당 화물의 상세보기 화면(SearchProductDetailPage)으로 이동하는 코드를 작성하면 됩니다.
                    // 아래 주석 처리된 부분이 해당 Navigator 코드이긴 한데, route를 못불러오는 문제가 있어서(라이브러리에는 해당 페이지가 없으므로)
                    // 아마 onTap 함수 자체를 넘겨받는 식으로 구현해야 할 것 같습니다.
                    // onTap: () {
                    //   Navigator.of(context).push(SearchProductDetailPage.route(
                    //       data['freight_id'], data['bl'].toString()));
                    // },
                    child: SvgPicture.asset(
                      'images/icon_detail_with_memo.svg',
                      package: 'pinokio_library',
                    )),
              )
            : InkWell(
                onTap: onTap,
                // TODO : 버튼 클릭 시 해당 화물의 상세보기 화면(SearchProductDetailPage)으로 이동하는 코드를 작성하면 됩니다.
                // 위에서 상술한 기능과 동일합니다.
                // onTap: () {
                //   Navigator.of(context).push(SearchProductDetailPage.route(
                //       data['freight_id'], data['bl'].toString()));
                // },
                child: SvgPicture.asset(
                  'images/icon_detail.svg',
                  package: 'pinokio_library',
                )),
      ),
    );
  }
}

Widget blTextBuilder(data, field) {
  return Center(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        (data['is_replied'] == 2)
            ? SvgPicture.asset(
                'images/icon_overdue.svg',
                package: 'pinokio_library',
              )
            : ((data['is_replied'] == 0)
                ? SvgPicture.asset(
                    'images/icon_urgent.svg',
                    package: 'pinokio_library',
                  )
                : Container()),
        const SizedBox(width: 5),
        ClipboardBLText(
            text: data['bl'] ?? '-', isReplied: data['is_replied'] ?? -1),
      ],
    ),
  );
}

Widget clipBoardTextBuilder(data, field) {
  if (field == 'photo_count') {
    return Center(
      child: ClipboardText(text: data['picture_id_list'].length.toString()),
    );
  }
  return Center(
    child:
        ClipboardText(text: data[field] == null ? '-' : data[field].toString()),
  );
}

Widget clipBoardDateBuilder(data, field) {
  return Center(
    child: ClipboardText(
        text: data[field].toString().length < 10
            ? data[field].toString()
            : data[field].toString().substring(0, 10)),
  );
}

Widget pictureBuilder(Map<String, dynamic> data, field, jwt) {
  // TODO: 사진 구현
  // Map<String, dynamic> data 는 search API의 result 값 한줄이 들어갑니다(freight_id 1개)
  // 먼저, data에 originalUrlList, thumbnailUrlList가 추가되어 있어야 합니다.
  // (두 List가 data에 추가되는 시점은 API를 decoding 할 때가 적합합니다.)
  // SearchImageList를 호출해서, data['originalUrlList'], data['thumbnailUrlList']로 접근해서 사용하는 방식으로 구현하시면 됩니다.
  // 더 좋은 방법이 있으면 구현방식을 바꿔도 무관합니다.
  return Container();
  // return SearchImageList(
  //     originalUrlList: data['originalUrlList']
  //     thumbnailUrlList: data['thumbnailUrlList'],
  //     bl: data['bl'],
  //     dataRowHeight: 75,
  //     jwt: jwt);
}

Widget dividerBuilder(data, field) {
  return Container(
    color: const Color.fromRGBO(201, 201, 201, 1),
    height: 75,
    width: 1,
  );
}

// DataColumn2를 상속받아 별도의 PinokioDataColumn을 정의합니다.
// DataColumn2에서 사용하는 주요 기능(label, tooltip, numeric, onSort)을 상속받아 사용합니다.

// [field] : 해당 컬럼에 들어갈 데이터의 key값을 정의합니다. search API의 Key값을 참고하면 됩니다.
// [fixedWidth] : 컬럼의 너비를 정의합니다. 기본값으로 150을 권장합니다.
// [isFixed] : true일 경우, 해당 컬럼을 좌측에 고정시킵니다. 미선언시 기본값은 false입니다.
// [type] : 컬럼에 들어갈 데이터의 형태를 정의합니다. 기본값은 clipboardtext입니다.

class PinokioDataColumn extends DataColumn2 {
  const PinokioDataColumn({
    required super.label,
    super.tooltip,
    super.numeric = false,
    super.onSort,
    required this.field,
    super.fixedWidth,
    this.isFixed = false,
    this.type = ColumnType.clipboardtext,
    this.originalUrlList,
    this.thumbnailUrlList,
  });

  final String field;
  final bool isFixed;
  final ColumnType? type;

  final List<List<String>>? originalUrlList;
  final List<List<String>>? thumbnailUrlList;
}

PinokioDataColumn dividerColumn = PinokioDataColumn(
  field: 'divider',
  label: Container(
    height: 75,
    width: 1,
    color: const Color.fromRGBO(201, 201, 201, 1),
  ),
  fixedWidth: 15,
  isFixed: true,
  type: ColumnType.divider,
);

// PinokioDataTable을 정의합니다.
// [rows] : 테이블에 들어갈 데이터를 정의합니다. search API의 result 값이 들어갑니다.
//          해당 데이터는 실질적으로 List<Map<String, dynamic>> 형태입니다.
// [columns] : 테이블에 들어갈 컬럼을 정의합니다. PinokioDataColumn을 참고하면 됩니다.
//          PinokioDataTable을 정의하는 페이지마다 별도로 선언해야 합니다.
//          추후 기능에 따라 컬럼을 추가하거나 삭제할 수 있습니다.
//          테이블에 표시되는 순서는 해당 리스트의 순서대로 표시됩니다.
//          (isFixed는 isFixed끼리, 아닌 컬럼은 아닌 컬럼끼리 순차적으로 표시됩니다.)
//          선언 시 직관성을 위해 isFixed를 먼저 선언하고, 그 다음에 나머지 컬럼을 선언하는 것을 권장합니다.
// [sortColumnIndex] : 현재 정렬중인 Column의 index입니다. 각 페이지별 state에서 관리합니다.
// [sortAscending] : 오름차순 / 내림차순인지에 대한 여부를 기록합니다.
// [rowsPerPage] : 한 페이지에 표시될 row의 수를 정의합니다.
// ================== 아래 3개는 선택 가능한 테이블에서만 사용합니다. ==================
// [selectable] : 데이터를 선택 가능한 테이블인지에 대한 여부를 정의합니다. 기본값은 false입니다.
//              | 선택 가능한 테이블은 이메일 전송 등의 기능을 사용합니다.
// [selectedList] : 선택 가능한 테이블에서 선택된 데이터의 리스트를 정의합니다. 기본값은 null입니다.
// [onSelectedChanged] : 선택 가능한 테이블에서 선택된 데이터의 리스트를 변경할 때 실행되는 함수를 정의합니다.
class PinokioDataTable extends StatefulWidget {
  const PinokioDataTable({
    super.key,
    required this.rows,
    required this.columns,
    required this.sortColumnIndex,
    required this.sortAscending,
    required this.rowsPerPage,
    required this.jwt,
    this.originalUrlList = const [],
    this.thumbnailUrlList = const [],
    this.selectable = false,
    this.selectedList,
    this.onSelectedChanged,
  });

  final List<Map<String, dynamic>> rows;
  final List<PinokioDataColumn> columns;
  final int sortColumnIndex;
  final bool sortAscending;
  final int rowsPerPage;
  final String jwt;
  final List<List<String>>? originalUrlList;
  final List<List<String>>? thumbnailUrlList;
  final bool selectable;
  final List<dynamic>? selectedList;
  final Function(bool?, dynamic)? onSelectedChanged;

  @override
  PinokioDataTableState createState() => PinokioDataTableState();
}

class PinokioDataTableState extends State<PinokioDataTable> {
  // onHover를 별도로 정의하기 때문에, hoverIdx를 통해 hover 상태를 관리합니다.
  int hoverIdx = -1;

  // PinokioDataColumn을 선언 할 때 사용했던 isFixed = true / false 에 따라서
  // 고정된 컬럼과 나머지 컬럼을 나누어서 정의합니다.
  late List<PinokioDataColumn> fixedColumnList = widget.columns
      .where((element) => element.isFixed)
      .toList(growable: false);
  late List<PinokioDataColumn> rightColumnList = widget.columns
      .where((element) => !element.isFixed)
      .toList(growable: false);

  // 최종적으로 PaginationDataTable2에 들어갈 컬럼을 정의합니다.
  // FixedColumn이 존재할 경우, DividerColumn를 포함하여 정의합니다.
  // FixedColumn이 존재하지 않을 경우, Divider 없이 RightColumn만 정의합니다.
  late List<PinokioDataColumn> finalColumnList = () {
    List<PinokioDataColumn> finalColumnList;
    if (fixedColumnList.isNotEmpty) {
      finalColumnList = [...fixedColumnList];
      if (rightColumnList.isNotEmpty) {
        finalColumnList.add(dividerColumn);
        finalColumnList.addAll(rightColumnList);
      }
    } else {
      finalColumnList = rightColumnList;
    }
    return finalColumnList;
  }();

  @override
  Widget build(BuildContext context) {
    // Column의 children으로 PaginationDataTable2, CustomizedPaginator를 정의합니다.

    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: PaginatedDataTable2(
                  wrapInCard: false,
                  minWidth: 4500,

                  // 고정시킬 Column이 없으면 0, 있으면 고정된 Column의 개수 + 1(Divider)을 정의합니다.
                  fixedLeftColumns: fixedColumnList.isEmpty
                      ? 0
                      : rightColumnList.isEmpty
                          ? fixedColumnList.length
                          : fixedColumnList.length + 1,
                  sortColumnIndex: widget.sortColumnIndex,
                  sortAscending: widget.sortAscending,
                  // 정렬아이콘을 커스터마이징 하기 위해 기존의 sortArrowBuilder를 빈 컨테이너로 정의합니다.
                  sortArrowBuilder: (ascending, sorted) =>
                      const SizedBox.shrink(),
                  sortArrowAlwaysVisible: true,
                  rowsPerPage: widget.rowsPerPage,
                  columnSpacing: 10,
                  dataRowHeight: 75,
                  showFirstLastButtons: true,
                  dividerThickness: 1,
                  // default checkbox도 customize를 위해 false로 설정
                  showCheckboxColumn: false,
                  // paginator를 customize하기 위해 숨기고, 별도로 정의합니다.
                  hidePaginator: true,
                  columns: finalColumnList,
                  source: PinokioDataTableSource(
                    rows: widget.rows,
                    columns: finalColumnList,
                    context: context,
                    selectable: widget.selectable,
                    onSelectedChanged: widget.onSelectedChanged,
                    selectedList: widget.selectedList,
                    hoverIdx: hoverIdx,
                    setHoverIdx: (index) {
                      setState(() {
                        hoverIdx = index;
                      });
                    },
                    jwt: widget.jwt,
                  )),
            ),
          ),
          // TODO : CustomizedPaginator를 정의합니다.
          // 별도의 Paginator를 구현하고, PaginatorController를 연결시켜서 Pagitnator가 작동하도록 구현하면 됩니다.
          // PaginatorController는 PaginationDataTable2 Reference를 참고해주세요.
          Container(child: const Text('Paginator 자리')),
        ],
      ),
    );
  }
}

class PinokioDataTableSource extends DataTableSource {
  PinokioDataTableSource({
    required this.context,
    required this.rows,
    required this.columns,
    required this.hoverIdx,
    required this.setHoverIdx,
    required this.jwt,
    this.selectable = false,
    this.selectedList,
    this.onSelectedChanged,
  });
  final BuildContext context;
  final List<dynamic> rows;
  final List<PinokioDataColumn> columns;
  final int hoverIdx;
  final Function(int index) setHoverIdx;
  final String jwt;

  final bool selectable;
  final List<dynamic>? selectedList;
  final Function(bool?, dynamic)? onSelectedChanged;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => rows.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow2? getRow(int index) {
    assert(index >= 0);
    assert(!selectable || selectedList != null);
    if (index >= rows.length) return null;
    final data = rows[index];
    List<DataCell> mycells = [];

    for (var column in columns) {
      Widget body;
      switch (column.type) {
        case ColumnType.clipboardtext:
          body = clipBoardTextBuilder(data, column.field);
          break;
        case ColumnType.clipboarddate:
          body = clipBoardDateBuilder(data, column.field);
          break;
        case ColumnType.checkbutton:
          body = checkButtonBuilder(data, column.field);
          break;
        case ColumnType.detailbutton:
          body = DetailButton(
            data: data,
            field: column.field,
            onTap: () {},
          );
          break;
        case ColumnType.bltext:
          body = blTextBuilder(data, column.field);
          break;
        case ColumnType.picture:
          body = pictureBuilder(data, column.field, jwt);
          break;
        case ColumnType.divider:
          body = Container(
            color: const Color.fromRGBO(201, 201, 201, 1),
            height: 75,
            width: 1,
          );
          break;
        default:
          body = Container();
          break;
      }

      mycells.add(DataCell(MouseRegion(
          onEnter: (_) {
            setHoverIdx(index);
          },
          onExit: (_) {
            setHoverIdx(-1);
          },
          child: body)));
    }

    return DataRow2.byIndex(
      index: index,
      decoration: BoxDecoration(
          border: const Border(
              top: BorderSide(
                  color: Color.fromRGBO(228, 228, 228, 1), width: 0.5),
              bottom: BorderSide(
                  color: Color.fromRGBO(228, 228, 228, 1), width: 1)),
          color: hoverIdx == index //  hover 상태인지 검사
              ? Colors.grey
              : selectable
                  ? selectedList!.contains(data['freight_id']) //  선택된 상태인지 검사
                      ? Colors.green.withOpacity(0.3)
                      : Colors.transparent
                  : Colors.transparent),
      selected:
          (selectable) ? selectedList!.contains(data['freight_id']) : false,
      onSelectChanged: (value) {
        if (selectable) {
          onSelectedChanged!(value, data);
        }
      },
      cells: mycells,
    );
  }
}
