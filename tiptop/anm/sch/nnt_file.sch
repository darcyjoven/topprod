/*
================================================================================
檔案代號:nnt_file
檔案名稱:资产抵押融资贷款
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table nnt_file
(
nnt01       varchar2(20) NOT NULL,   /*相关单号                               */
                                     /*相關單號                               */
nnt02       number(5) NOT NULL,      /*行序                                   */
nnt03       varchar2(10) NOT NULL,   /*财产编号                               */
                                     /*財產編號                               */
nnt04       varchar2(4) NOT NULL,    /*附号                                   */
                                     /*附號                                   */
nnt05       varchar2(80),            /*财产名称                               */
                                     /*財產名稱                               */
nnt06       varchar2(4),             /*单位                                   */
                                     /*單位                                   */
nnt07       number(5),               /*数量                                   */
                                     /*數量                                   */
nnt08       number(20,6),            /*未折减额                               */
                                     /*未折減額      02/11/26 alter           */
nnt09       number(20,6),            /*取得成本                               */
                                     /*取得成本      02/11/26 alter           */
nnt10       number(20,6),            /*抵押金额                               */
                                     /*抵押金額      02/11/26 alter           */
nnt11       varchar2(1),             /*No Use                                 */
nnt12       varchar2(1),             /*No Use                                 */
nnt13       varchar2(1),             /*No Use                                 */
nnt14       varchar2(1),             /*No Use                                 */
nnt15       varchar2(1),             /*No Use                                 */
nntlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table nnt_file add  constraint nnt_pk primary key  (nnt01,nnt02,nnt03,nnt04) enable validate;
grant select on nnt_file to tiptopgp;
grant update on nnt_file to tiptopgp;
grant delete on nnt_file to tiptopgp;
grant insert on nnt_file to tiptopgp;
grant index on nnt_file to public;
grant select on nnt_file to ods;
