/*
================================================================================
檔案代號:geg_file
檔案名稱:编码规则单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table geg_file
(
geg01       varchar2(10) NOT NULL,   /*编码类型                               */
                                     /*編碼類別                               */
geg012      number(5) NOT NULL,      /*段次                                   */
geg013      varchar2(30) NOT NULL,   /*前段编码                               */
                                     /*前段編碼                               */
geg02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
geg03       varchar2(30),            /*编码编号                               */
                                     /*編碼編號                               */
geg04       varchar2(80),            /*编码名称                               */
                                     /*編碼名稱                               */
geg05       varchar2(30),            /*汇总编号                               */
                                     /*匯總編號               #該段次最終編號 */
geg06       varchar2(1),             /*No Use                                 */
geg07       varchar2(1),             /*No Use                                 */
geg08       varchar2(1)              /*No Use                                 */
);

alter table geg_file add  constraint geg_pk primary key  (geg01,geg012,geg013,geg02) enable validate;
grant select on geg_file to tiptopgp;
grant update on geg_file to tiptopgp;
grant delete on geg_file to tiptopgp;
grant insert on geg_file to tiptopgp;
grant index on geg_file to public;
grant select on geg_file to ods;
