/*
================================================================================
檔案代號:isg_file
檔案名稱:銷售發票傳入單頭檔
檔案目的:
上游檔案:
下游檔案:N
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table isg_file
(
isg01       varchar2(20) DEFAULT ' ' NOT NULL, /*账款编号*/
isg02       number(5),               /*商品行数                               */
isg03       varchar2(80),            /*购方名称                               */
isg04       varchar2(20),            /*购方税号                               */
isg05       varchar2(80),            /*购方地址电话                           */
isg06       varchar2(80),            /*购方银行帐号                           */
isg07       varchar2(255),           /*备注                                   */
isg08       varchar2(10),            /*复核人                                 */
isg09       varchar2(10),            /*收款人                                 */
isg10       varchar2(80),            /*清点行商品名称                         */
isg11       date,                    /*单据日起                               */
isg12       varchar2(80),            /*销方银行帐号                           */
isg13       varchar2(80)             /*销方地址电话                           */
);

grant select on isg_file to tiptopgp;
grant update on isg_file to tiptopgp;
grant delete on isg_file to tiptopgp;
grant insert on isg_file to tiptopgp;
grant index on isg_file to public;
grant select on isg_file to ods;
