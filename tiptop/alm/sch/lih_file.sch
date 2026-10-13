/*
================================================================================
檔案代號:lih_file
檔案名稱:商户预租协议维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lih_file
(
lih01       varchar2(20) DEFAULT ' ' NOT NULL, /*預租協議單號*/
lih02       varchar2(1) DEFAULT ' ' NOT NULL, /*預租性質 1:招商預租 2:續約預 */
lih03       varchar2(20),            /*原合同编号                             */
lih04       varchar2(20),            /*新合同编号                             */
lih05       varchar2(10),            /*楼栋编号                               */
lih06       varchar2(10),            /*楼层编号                               */
lih07       varchar2(20),            /*摊位编号                               */
lih08       varchar2(10),            /*商户编号                               */
lih09       varchar2(10),            /*品牌编号                               */
lih10       varchar2(10),            /*费用编号                               */
lih11       number(20,6),            /*預收款金額                             */
lih12       varchar2(20),            /*费用单编号                             */
lih13       date,                    /*签订日期                               */
lih14       date,                    /*預租開始日期                           */
lih15       date,                    /*預租結束日期                           */
lih16       date,                    /*合同开始日期                           */
lih17       date,                    /*合同结束日期                           */
lih18       date,                    /*终止日期                               */
lih19       varchar2(10),            /*终止人                                 */
lih20       varchar2(10),            /*簽約人                                 */
lih21       varchar2(1) DEFAULT ' ' NOT NULL, /*統一收銀否*/
lih22       varchar2(255),           /*备注                                   */
lih23       varchar2(1) DEFAULT ' ' NOT NULL, /*是否签核*/
lih24       varchar2(1) DEFAULT ' ' NOT NULL, /*状况码*/
lihacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
lihcond     date,                    /*审核日期                               */
lihconf     varchar2(1) DEFAULT ' ' NOT NULL, /*确认码*/
lihconu     varchar2(10),            /*审核人                                 */
lihcrat     date,                    /*资料创建日                             */
lihdate     date,                    /*最近更改日                             */
lihgrup     varchar2(10),            /*资料所有群                             */
lihlegal    varchar2(10),            /*法人                                   */
lihmodu     varchar2(10),            /*资料更改者                             */
lihorig     varchar2(10),            /*资料建立部门                           */
lihoriu     varchar2(10),            /*资料建立者                             */
lihplant    varchar2(10),            /*门店编号                               */
lihuser     varchar2(10),            /*资料所有者                             */
lihpos      varchar2(1) DEFAULT ' ' NOT NULL /*已传POS否*/
);

alter table lih_file add  constraint lih_pk primary key  (lih01) enable validate;
grant select on lih_file to tiptopgp;
grant update on lih_file to tiptopgp;
grant delete on lih_file to tiptopgp;
grant insert on lih_file to tiptopgp;
grant index on lih_file to public;
grant select on lih_file to ods;
