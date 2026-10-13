/*
================================================================================
檔案代號:qde_file
檔案名稱:FQC联产品资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table qde_file
(
qde01       varchar2(20) NOT NULL,   /*FQC单号                                */
                                     /*FQC單號                                */
qde02       varchar2(20) NOT NULL,   /*工单单号                               */
                                     /*工單單號                               */
qde03       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
qde04       date,                    /*检验日期                               */
                                     /*檢驗日期                               */
qde05       varchar2(40),            /*联产品料号                             */
                                     /*聯產品料號                             */
qde06       number(15,3),            /*数量                                   */
                                     /*數量                                   */
qde08       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
qde09       varchar2(10),            /*仓库                                   */
                                     /*倉庫                                   */
qde10       varchar2(10),            /*库位                                   */
                                     /*儲位                                   */
qde11       varchar2(24),            /*批量                                   */
qde12       varchar2(4),             /*联产品单位                             */
                                     /*聯產品單位                             */
qde13       number(20,8),            /*联产品对主件转换率                     */
                                     /*聯產品對主件轉換率                     */
qdeplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
qdelegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table qde_file add  constraint qde_pk primary key  (qde01,qde02,qde03) enable validate;
grant select on qde_file to tiptopgp;
grant update on qde_file to tiptopgp;
grant delete on qde_file to tiptopgp;
grant insert on qde_file to tiptopgp;
grant index on qde_file to public;
grant select on qde_file to ods;
