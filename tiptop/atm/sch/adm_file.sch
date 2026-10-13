/*
================================================================================
檔案代號:adm_file
檔案名稱:派车单其它托运物品档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table adm_file
(
adm01       varchar2(20) NOT NULL,   /*派车单单号                             */
adm02       number(5) NOT NULL,      /*项次                                   */
adm03       varchar2(1),             /*类型                                   */
adm04       number(5),               /*件数                                   */
adm05       varchar2(80),            /*说明                                   */
adm06       varchar2(10),            /*委托人                                 */
adm07       varchar2(40),            /*收件单位                               */
adm08       varchar2(40),            /*收件人                                 */
admplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
admlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table adm_file add  constraint adm_pk primary key  (adm01,adm02) enable validate;
grant select on adm_file to tiptopgp;
grant update on adm_file to tiptopgp;
grant delete on adm_file to tiptopgp;
grant insert on adm_file to tiptopgp;
grant index on adm_file to public;
grant select on adm_file to ods;
