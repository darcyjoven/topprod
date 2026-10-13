/*
================================================================================
檔案代號:ish_file
檔案名稱:銷售發票傳入單身檔
檔案目的:
上游檔案:
下游檔案:N
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ish_file
(
ish01       varchar2(20) DEFAULT ' ' NOT NULL, /*帳款編號*/
ish02       number(5) DEFAULT '0' NOT NULL, /*項次*/
ish03       varchar2(40),            /*料號                                   */
ish04       varchar2(120),           /*貨物名稱(品名)                         */
ish05       varchar2(4),             /*計量單位                               */
ish06       varchar2(120),           /*規格                                   */
ish07       number(15,3) DEFAULT '0' NOT NULL, /*數量*/
ish08       number(20,6) DEFAULT '0' NOT NULL, /*未稅金額*/
ish09       number(9,4),             /*稅率                                   */
ish10       varchar2(5),             /*商品稅目                               */
ish11       number(20,6) DEFAULT '0' NOT NULL, /*折扣金額*/
ish12       number(20,6) DEFAULT '0' NOT NULL, /*稅額*/
ish13       number(20,6) DEFAULT '0' NOT NULL, /*折扣稅率*/
ish14       number(9,4),             /*折扣率                                 */
ish15       number(20,6) DEFAULT '0' NOT NULL, /*單價*/
ish16       varchar2(1) DEFAULT ' ' NOT NULL /*價格方式*/
);

grant select on ish_file to tiptopgp;
grant update on ish_file to tiptopgp;
grant delete on ish_file to tiptopgp;
grant insert on ish_file to tiptopgp;
grant index on ish_file to public;
grant select on ish_file to ods;
