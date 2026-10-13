/*
================================================================================
檔案代號:oao_file
檔案名稱:单据备注档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table oao_file
(
oao01       varchar2(20) NOT NULL,   /*单据单号                               */
                                     /*單據單號                               */
oao03       number(5) NOT NULL,      /*项次                                   */
                                     /*項次 (0 表示整張備註,123...表示單身備註)*/
oao04       number(5) NOT NULL,      /*行序                                   */
oao05       varchar2(1) NOT NULL,    /*打印码                                 */
                                     /*列印碼(1.列印於前 2.列印於後 0.內部參考)*/
oao06       varchar2(255),           /*备注                                   */
                                     /*備註 (單身備註且列印於後, 限制char(30))*/
oao02       varchar2(20) DEFAULT ' ' NOT NULL /*程序编号*/
);

alter table oao_file add  constraint oao_pk primary key  (oao01,oao02,oao03,oao04,oao05) enable validate;
grant select on oao_file to tiptopgp;
grant update on oao_file to tiptopgp;
grant delete on oao_file to tiptopgp;
grant insert on oao_file to tiptopgp;
grant index on oao_file to public;
grant select on oao_file to ods;
