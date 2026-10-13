/*
================================================================================
檔案代號:gsa_file
檔案名稱:投资种类基本资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table gsa_file
(
gsa01       varchar2(4) NOT NULL,    /*种类                                   */
gsa02       varchar2(80),            /*名称                                   */
gsa03       varchar2(1),             /*No Use                                 */
gsa04       varchar2(24),            /*投资会计科目                           */
gsa05       varchar2(24),            /*投资收益科目                           */
gsa06       varchar2(24),            /*投资损失科目                           */
gsaacti     varchar2(1),             /*资料有效码                             */
gsauser     varchar2(10),            /*资料所有者                             */
gsagrup     varchar2(10),            /*资料所有部门                           */
gsamodu     varchar2(10),            /*资料更改者                             */
gsadate     date,                    /*最近更改日                             */
gsa041      varchar2(24),            /*投资会计科目二                         */
gsa051      varchar2(24),            /*投资收益科目二                         */
gsa061      varchar2(24),            /*投资损失科目二                         */
gsaorig     varchar2(10),            /*资料建立部门                           */
gsaoriu     varchar2(10)             /*资料建立者                             */
);

alter table gsa_file add  constraint gsa_pk primary key  (gsa01) enable validate;
grant select on gsa_file to tiptopgp;
grant update on gsa_file to tiptopgp;
grant delete on gsa_file to tiptopgp;
grant insert on gsa_file to tiptopgp;
grant index on gsa_file to public;
grant select on gsa_file to ods;
