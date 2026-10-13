/*
================================================================================
檔案代號:ges_file
檔案名稱:变数基本资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ges_file
(
ges01       varchar2(5) NOT NULL,    /*变数代码                               */
ges02       varchar2(80),            /*变数名称                               */
ges03       varchar2(2),             /*变数性质                               */
ges04       varchar2(255),           /*缺省值                                 */
ges05       number(5),               /*小数位数                               */
ges06       varchar2(10),            /*No Use                                 */
ges07       varchar2(10),            /*No Use                                 */
ges08       varchar2(10),            /*No Use                                 */
gesacti     varchar2(1)              /*有效否(y/n)                            */
);

alter table ges_file add  constraint ges_pk primary key  (ges01) enable validate;
grant select on ges_file to tiptopgp;
grant update on ges_file to tiptopgp;
grant delete on ges_file to tiptopgp;
grant insert on ges_file to tiptopgp;
grant index on ges_file to public;
grant select on ges_file to ods;
