/*
================================================================================
檔案代號:tmn_file
檔案名稱:凭证缺号档
檔案目的:存放已被占用的凭证缺号
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table tmn_file
(
tmn01       varchar2(10) NOT NULL,   /*总账营运中心                           */
tmn02       varchar2(20) NOT NULL,   /*凭证号码                               */
tmn03       varchar2(1),             /*No Use                                 */
tmn04       varchar2(1),             /*No Use                                 */
tmn05       number(5),               /*No Use                                 */
tmn06       varchar2(5) NOT NULL     /*帐套                                   */
);

alter table tmn_file add  constraint tmn_pk primary key  (tmn01,tmn02,tmn06) enable validate;
grant select on tmn_file to tiptopgp;
grant update on tmn_file to tiptopgp;
grant delete on tmn_file to tiptopgp;
grant insert on tmn_file to tiptopgp;
grant index on tmn_file to public;
grant select on tmn_file to ods;
