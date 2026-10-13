/*
================================================================================
檔案代號:axy_file
檔案名稱:传票明细
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table axy_file
(
axy01       varchar2(10),            /*公司编号                               */
axy02       varchar2(5),             /*帐套                                   */
axy03       number(5),               /*年度                                   */
axy04       varchar2(10),            /*期别                                   */
axy05       date,                    /*凭证日期                               */
axy06       varchar2(20),            /*凭证编号                               */
axy07       number(5),               /*项次                                   */
axy08       varchar2(255),           /*摘要                                   */
axy09       varchar2(24),            /*会计科目                               */
axy10       varchar2(1),             /*借/贷                                  */
axy11       number(20,6),            /*金额                                   */
axy12       varchar2(10),            /*群组分类                               */
axylegal    varchar2(10) NOT NULL    /*所属法人                               */
);

grant select on axy_file to tiptopgp;
grant update on axy_file to tiptopgp;
grant delete on axy_file to tiptopgp;
grant insert on axy_file to tiptopgp;
grant index on axy_file to public;
grant select on axy_file to ods;
