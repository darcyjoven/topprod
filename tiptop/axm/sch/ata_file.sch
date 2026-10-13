/*
================================================================================
檔案代號:ata_file
檔案名稱:款式明細檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ata_file
(
ata00       varchar2(40) DEFAULT ' ' NOT NULL, /*程序编号*/
ata01       varchar2(20) DEFAULT ' ' NOT NULL, /*Documentary number*/
ata02       number(5) DEFAULT '0' NOT NULL, /*单据项次*/
ata03       number(5) DEFAULT '0' NOT NULL, /*项次*/
ata04       varchar2(40),            /*款式明細                               */
ata05       varchar2(40),            /*款号                                   */
ata06       varchar2(10),            /*颜色                                   */
ata07       varchar2(10),            /*版本                                   */
ata08       number(15,3) DEFAULT '0' NOT NULL, /*屬性值-數值型*/
ata09       number(15,3) DEFAULT '0' NOT NULL, /*屬性值-數值型*/
ata10       number(15,3) DEFAULT '0' NOT NULL, /*屬性值-數值型*/
ata11       number(15,3) DEFAULT '0' NOT NULL, /*屬性值-數值型*/
ata12       number(15,3) DEFAULT '0' NOT NULL, /*屬性值-數值型*/
ata13       number(15,3) DEFAULT '0' NOT NULL, /*屬性值-數值型*/
ata14       number(15,3) DEFAULT '0' NOT NULL, /*屬性值-數值型*/
ata15       number(15,3) DEFAULT '0' NOT NULL, /*屬性值-數值型*/
ata16       number(15,3) DEFAULT '0' NOT NULL, /*屬性值-數值型*/
ata17       number(15,3) DEFAULT '0' NOT NULL, /*屬性值-數值型*/
ata18       number(15,3) DEFAULT '0' NOT NULL, /*屬性值-數值型*/
ata19       number(15,3) DEFAULT '0' NOT NULL, /*屬性值-數值型*/
ata20       number(15,3) DEFAULT '0' NOT NULL, /*屬性值-數值型*/
ata21       number(15,3) DEFAULT '0' NOT NULL, /*屬性值-數值型*/
ata22       number(15,3) DEFAULT '0' NOT NULL, /*屬性值-數值型*/
ata23       number(15,3) DEFAULT '0' NOT NULL, /*屬性值-數值型*/
ata24       number(15,3) DEFAULT '0' NOT NULL, /*屬性值-數值型*/
ata25       number(15,3) DEFAULT '0' NOT NULL, /*屬性值-數值型*/
ata26       number(15,3) DEFAULT '0' NOT NULL, /*屬性值-數值型*/
ata27       number(15,3) DEFAULT '0' NOT NULL, /*屬性值-數值型*/
ata28       number(15,3) DEFAULT '0' NOT NULL /*合计*/
);

grant select on ata_file to tiptopgp;
grant update on ata_file to tiptopgp;
grant delete on ata_file to tiptopgp;
grant insert on ata_file to tiptopgp;
grant index on ata_file to public;
grant select on ata_file to ods;
