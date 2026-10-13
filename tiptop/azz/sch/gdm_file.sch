/*
================================================================================
檔案代號:gdm_file
檔案名稱:Genero Report多語言檔案
檔案目的:
上游檔案:gdw_file
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gdm_file
(
gdm01       number(10) DEFAULT '1' NOT NULL,
gdm02       number(5) DEFAULT '1' NOT NULL, /*序号*/
gdm03       varchar2(1) DEFAULT ' ' NOT NULL, /*语言别*/
gdm04       varchar2(50),
gdm05       varchar2(1) DEFAULT '1' NOT NULL, /*类型*/
gdm06       varchar2(1) DEFAULT ' ' NOT NULL, /*字段属性*/
gdm07       number(15,3),            /*定位点                                 */
gdm08       number(15,3),            /*字段宽度                               */
gdm09       number(5),               /*行序                                   */
gdm10       number(5),               /*字段顺序                               */
gdm11       varchar2(20),
gdm12       number(5),
gdm13       varchar2(1) DEFAULT ' ' NOT NULL,
gdm14       varchar2(20),            /*颜色                                   */
gdm15       number(15,3),
gdm16       varchar2(20),
gdm17       number(5),
gdm18       varchar2(1) DEFAULT ' ' NOT NULL,
gdm19       varchar2(20),
gdm20       varchar2(1) DEFAULT ' ' NOT NULL,
gdm21       varchar2(1) DEFAULT ' ' NOT NULL,
gdm22       varchar2(1) DEFAULT ' ' NOT NULL,
gdm23       varchar2(255),
gdm24       varchar2(1) DEFAULT ' ' NOT NULL,
gdm25       varchar2(1) DEFAULT ' ' NOT NULL,
gdm26       varchar2(255),
gdm27       varchar2(255)
);

alter table gdm_file add  constraint gdm_pk primary key  (gdm01,gdm02,gdm03) enable validate;
grant select on gdm_file to tiptopgp;
grant update on gdm_file to tiptopgp;
grant delete on gdm_file to tiptopgp;
grant insert on gdm_file to tiptopgp;
grant index on gdm_file to public;
grant select on gdm_file to ods;
