/*
================================================================================
檔案代號:lni_file
檔案名稱:生效范围资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lni_file
(
lni01       varchar2(20) DEFAULT ' ' NOT NULL, /*单据号*/
lni02       varchar2(1) DEFAULT ' ' NOT NULL, /*类型*/
lni03       number(5) DEFAULT '0',   /*版本
                                                                                  */
lni04       varchar2(10) DEFAULT ' ' NOT NULL, /*生效门店编号*/
lni05       varchar2(10),            /*No Use                                 */
lni06       varchar2(10),            /*No Use                                 */
lni07       varchar2(10),            /*产品分类                               */
lni08       varchar2(20) DEFAULT ' ' NOT NULL, /*摊位编号*/
lni09       date,                    /*生效日期                               */
lni10       date,                    /*失效日期                               */
lni11       varchar2(10),            /*更改人员                               */
lni12       date,                    /*更改日期                               */
lni13       varchar2(1),             /*有效否                                 */
lnilegal    varchar2(10) NOT NULL,   /*所属法人                               */
lniplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
lni14       varchar2(10) DEFAULT ' ' NOT NULL, /*制订营运中心*/
lni15       varchar2(20) DEFAULT ' ' NOT NULL /*卡种代号*/
);

alter table lni_file add  constraint lni_pk primary key  (lni01,lni02,lni04,lni08,lni14,lni15,lniplant) enable validate;
grant select on lni_file to tiptopgp;
grant update on lni_file to tiptopgp;
grant delete on lni_file to tiptopgp;
grant insert on lni_file to tiptopgp;
grant index on lni_file to public;
grant select on lni_file to ods;
