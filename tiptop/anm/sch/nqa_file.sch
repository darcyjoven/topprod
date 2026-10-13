/*
================================================================================
檔案代號:nqa_file
檔案名稱:参数设置
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table nqa_file
(
nqa00       varchar2(1) NOT NULL,    /*key value                              */
nqa01       varchar2(4),             /*集团币种                               */
nqa02       varchar2(1),             /*No Use                                 */
nqa03       varchar2(1),             /*No Use                                 */
nqa04       varchar2(1),             /*No Use                                 */
nqa05       varchar2(1),             /*No Use                                 */
nqaacti     varchar2(1),             /*资料有效码                             */
nqauser     varchar2(10),            /*资料所有者                             */
nqagrup     varchar2(10),            /*资料所有群                             */
nqamodu     varchar2(10),            /*资料更改者                             */
nqadate     date,                    /*最近更改日                             */
nqaorig     varchar2(10),            /*资料建立部门                           */
nqaoriu     varchar2(10)             /*资料建立者                             */
);

alter table nqa_file add  constraint nqa_pk primary key  (nqa00) enable validate;
grant select on nqa_file to tiptopgp;
grant update on nqa_file to tiptopgp;
grant delete on nqa_file to tiptopgp;
grant insert on nqa_file to tiptopgp;
grant index on nqa_file to public;
grant select on nqa_file to ods;
