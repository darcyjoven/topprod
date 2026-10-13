/*
================================================================================
檔案代號:bgt_file
檔案名稱:劳健保费率档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bgt_file
(
bgt01       number(10) NOT NULL,     /*起始薪资级距                           */
                                     /*起始薪資級距                           */
bgt02       number(10) NOT NULL,     /*截止薪资级距                           */
                                     /*截止薪資級距                           */
bgt03       number(20,6),            /*劳保费                                 */
                                     /*勞保費                                 */
bgt04       number(20,6),            /*健保费                                 */
                                     /*健保費                                 */
bgtacti     varchar2(1),             /*资料有效码                             */
bgtuser     varchar2(10),            /*资料所有者                             */
bgtgrup     varchar2(10),            /*资料所有部门                           */
bgtmodu     varchar2(10),            /*资料更改者                             */
bgtdate     date,                    /*最近更改日                             */
bgtorig     varchar2(10),            /*资料建立部门                           */
bgtoriu     varchar2(10)             /*资料建立者                             */
);

alter table bgt_file add  constraint bgt_pk primary key  (bgt01,bgt02) enable validate;
grant select on bgt_file to tiptopgp;
grant update on bgt_file to tiptopgp;
grant delete on bgt_file to tiptopgp;
grant insert on bgt_file to tiptopgp;
grant index on bgt_file to public;
grant select on bgt_file to ods;
