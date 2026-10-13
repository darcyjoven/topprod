/*
================================================================================
檔案代號:aze_file
檔案名稱:签核等级单头
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table aze_file
(
aze01       varchar2(4) NOT NULL,    /*签核等级                               */
                                     /*簽核等級                               */
aze02       varchar2(80),            /*说明                                   */
                                     /*說明                                   */
aze03       varchar2(80),            /*说明                                   */
                                     /*說明                                   */
aze04       varchar2(80),            /*说明                                   */
                                     /*說明                                   */
aze05       varchar2(80),            /*说明                                   */
                                     /*說明                                   */
aze06       varchar2(80),            /*说明                                   */
                                     /*說明                                   */
aze07       varchar2(1),             /*是否需查看后方可签核                   */
                                     /*是否需查看後方可簽核 (Y/N)             */
aze08       varchar2(1),             /*是否由系统自动赋予签核等级             */
                                     /*是否由系統自動賦予簽核等級(Y/N)        */
aze09       number(5),               /*签核单据别                             */
                                     /*簽核單據別                             */
                                     /*1.報價單 2.請購單 3.採購單 4.傳票      */
                                     /*5.銷貨單 6.傳票底稿                    */
                                     /*7.常用傳票(固定金額)(固定比率)92/08/01合*/
                                     /*9.調撥 10.設計變更單 11.應付帳款       */
                                     /*12.付款單   13.銷單(內銷)出貨單        */
                                     /*14.銷單(外銷)出貨單 15.銷貨折讓單      */
                                     /*16.銷退單  17.預收貨款單 18.複運出口出貨*/
                                     /*19.收款沖帳 20.開狀單 21.贖單          */
                                     /*22:借項單 23:貸項單  24:呆帳單         */
                                     /*25.訂單   26.訂單變更                  */
aze10       varchar2(80),            /*赋予条件                               */
                                     /*賦予條件                               */
aze11       varchar2(80),            /*赋予条件                               */
                                     /*賦予條件                               */
azeacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
azeuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
azegrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
azemodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
azedate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
azeoriu     varchar2(10),            /*资料建立者                             */
azeorig     varchar2(10)             /*资料建立部门                           */
);

alter table aze_file add  constraint aze_pk primary key  (aze01) enable validate;
grant select on aze_file to tiptopgp;
grant update on aze_file to tiptopgp;
grant delete on aze_file to tiptopgp;
grant insert on aze_file to tiptopgp;
grant index on aze_file to public;
grant select on aze_file to ods;
