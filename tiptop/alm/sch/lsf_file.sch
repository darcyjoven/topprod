/*
================================================================================
檔案代號:lsf_file
檔案名稱:竞争对手媒体追踪档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lsf_file
(
lsf01       varchar2(10),            /*竞争对手编号                           */
lsf02       varchar2(50),            /*投放媒体                               */
lsf03       date,                    /*刊播日期                               */
lsf04       varchar2(30),            /*版面                                   */
lsf05       varchar2(30),            /*规格                                   */
lsf06       number(5),               /*刊发次数                               */
lsf07       number(20,2),            /*刊例价格                               */
lsf08       varchar2(50),            /*内容                                   */
lsf09       varchar2(50)             /*备注                                   */
);

grant select on lsf_file to tiptopgp;
grant update on lsf_file to tiptopgp;
grant delete on lsf_file to tiptopgp;
grant insert on lsf_file to tiptopgp;
grant index on lsf_file to public;
grant select on lsf_file to ods;
