/*
================================================================================
檔案代號:oba_file
檔案名稱:产品分类档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table oba_file
(
oba01       varchar2(10) NOT NULL,   /*产品分类码                             */
                                     /*產品分類碼                             */
oba02       varchar2(80),            /*分类名称                               */
                                     /*分類名稱                               */
oba03       varchar2(1),             /*No Use                                 */
oba04       varchar2(1),             /*No Use                                 */
oba05       varchar2(1),             /*No Use                                 */
oba06       varchar2(1),             /*No Use                                 */
oba07       number(9,3),             /*调拨计价加计百分比                     */
                                     /*轉撥計價加計百分比 add in 00/04/18     */
oba08       varchar2(1),             /*计划期别格式                           */
oba09       number(5),               /*期数                                   */
oba10       varchar2(10),            /*成本中心                               */
oba11       varchar2(24),            /*销货收入科目                           */
oba111      varchar2(24),            /*销货收入科目二                         */
oba12       number(5),               /*层级                                   */
oba13       varchar2(10),            /*上级分类码                             */
oba14       number(5),               /*下级分类数                             */
oba15       varchar2(10),            /*所属一级分类                           */
obaacti     varchar2(1) DEFAULT 'Y' NOT NULL, /*有效否*/
obapos      varchar2(1) DEFAULT '1' NOT NULL, /*已传POS否*/
                                     /*已传POS否 1.新增未下传 2.更改未下传 3.已下传*/
oba16       varchar2(24),
oba161      varchar2(24),
oba17       varchar2(24),            /*外销收入科目                           */
oba171      varchar2(24),            /*外销收入科目二                         */
oba18       varchar2(24),            /*外销成本科目                           */
oba181      varchar2(24)             /*外销成本科目二                         */
);

alter table oba_file add  constraint oba_pk primary key  (oba01) enable validate;
grant select on oba_file to tiptopgp;
grant update on oba_file to tiptopgp;
grant delete on oba_file to tiptopgp;
grant insert on oba_file to tiptopgp;
grant index on oba_file to public;
grant select on oba_file to ods;
