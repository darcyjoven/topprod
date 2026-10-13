/*
================================================================================
檔案代號:qao_file
檔案名稱:QC单据备注档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table qao_file
(
qao01       varchar2(20) NOT NULL,   /*单据单号                               */
                                     /*單據單號                               */
qao02       number(5) NOT NULL,      /*收货项次                               */
                                     /*收貨項次#FQC.PQC 為 0                  */
qao021      number(5) NOT NULL,      /*检验批号                               */
                                     /*檢驗批號(分批檢驗順序)    #FQC.PQC為 0 */
qao03       number(5) NOT NULL,      /*项次                                   */
                                     /*項次 (0 表示整張備註,123...表示單身備註)*/
qao04       number(5) NOT NULL,      /*行序                                   */
qao05       varchar2(1) NOT NULL,    /*打印码                                 */
                                     /*列印碼(1.列印於前 2.列印於後 0.內部參考)*/
qao06       varchar2(255),           /*备注                                   */
                                     /*備註 (單身備註且列印於後, 限制char(30))*/
qaoplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
qaolegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table qao_file add  constraint qao_pk primary key  (qao01,qao02,qao021,qao03,qao04,qao05) enable validate;
grant select on qao_file to tiptopgp;
grant update on qao_file to tiptopgp;
grant delete on qao_file to tiptopgp;
grant insert on qao_file to tiptopgp;
grant index on qao_file to public;
grant select on qao_file to ods;
