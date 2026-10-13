/*
================================================================================
檔案代號:tsa_file
檔案名稱:提案明细资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table tsa_file
(
tsa01       varchar2(20) NOT NULL,   /*提案单号                               */
tsa02       number(5) NOT NULL,      /*客户项次                               */
tsa03       number(5) NOT NULL,      /*产品项次                               */
tsa04       number(15,3),            /*目标数量                               */
tsa05       number(20,6),            /*目标税前金额                           */
tsa06       number(15,3),            /*No Use                                 */
tsa07       number(20,6),            /*No Use                                 */
tsa08       number(20,6),            /*目标含税金额                           */
tsa09       number(20,6),            /*No Use                                 */
tsaplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
tsalegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table tsa_file add  constraint tsa_pk primary key  (tsa01,tsa02,tsa03) enable validate;
grant select on tsa_file to tiptopgp;
grant update on tsa_file to tiptopgp;
grant delete on tsa_file to tiptopgp;
grant insert on tsa_file to tiptopgp;
grant index on tsa_file to public;
grant select on tsa_file to ods;
