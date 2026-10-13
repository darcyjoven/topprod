/*
================================================================================
檔案代號:con_file
檔案名稱:合同标准BOM单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table con_file
(
con01       varchar2(40) NOT NULL,   /*商品编号                               */
con012      varchar2(1),             /*No Use                                 */
con013      varchar2(20) NOT NULL,   /*版本编号                               */
con02       number(5),               /*项次                                   */
con03       varchar2(40) NOT NULL,   /*商品编号                               */
con032      varchar2(1),             /*No Use                                 */
con04       varchar2(4),             /*单位                                   */
con05       number(16,8),            /*单耗                                   */
con06       number(9,5),             /*损耗率                                 */
con07       varchar2(10),            /*原产国                                 */
con08       varchar2(10) NOT NULL,   /*海关编号                               */
con09       varchar2(1),             /*No Use                                 */
con10       varchar2(1),             /*No Use                                 */
con061      number(15,3) DEFAULT '0' NOT NULL,
con062      number(9,4)              /*损耗批量                               */
);

alter table con_file add  constraint con_pk primary key  (con01,con013,con08,con03) enable validate;
grant select on con_file to tiptopgp;
grant update on con_file to tiptopgp;
grant delete on con_file to tiptopgp;
grant insert on con_file to tiptopgp;
grant index on con_file to public;
grant select on con_file to ods;
