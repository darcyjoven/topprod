/*
================================================================================
檔案代號:slf_file
檔案名稱:基础码尺寸表档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table slf_file
(
slf01       varchar2(10) DEFAULT ' ' NOT NULL, /*制单号*/
slf02       varchar2(20) DEFAULT ' ' NOT NULL, /*款式号*/
slf03       varchar2(10) DEFAULT ' ' NOT NULL, /*尺寸*/
slf04       number(5) DEFAULT '0' NOT NULL, /*项次*/
slf05       varchar2(4),             /*部位顺序                               */
slf06       varchar2(10),            /*部位                                   */
slf07       varchar2(10),            /*度法                                   */
slf08       varchar2(1),             /*布纹                                   */
slf09       varchar2(10),            /*度量长度分数                           */
slf09a      number(15,3),            /*度量长度小数                           */
slf10       number(15,3),            /*纸样缩率                               */
slf11       varchar2(10),            /*样品纸样尺寸分数                       */
slf11a      number(15,3),            /*样品纸样尺寸小数                       */
slf12       varchar2(10),            /*洗前分数                               */
slf12a      number(15,3),            /*洗前小数                               */
slf13       varchar2(10),            /*烫前分数                               */
slf13a      number(15,3),            /*烫前小数                               */
slf14       varchar2(10),            /*烫后分数                               */
slf14a      number(15,3),            /*烫后小数                               */
slf15       varchar2(10),            /*大货纸样尺寸分数                       */
slf15a      number(15,3),            /*大货纸样尺寸小数                       */
slf16       varchar2(10),            /*大货洗前尺寸分数                       */
slf16a      number(15,3),            /*大货洗前尺寸小数                       */
slf17       varchar2(15),            /*公差                                   */
slf18       varchar2(255),           /*備注                                   */
slf19       varchar2(10) DEFAULT ' ' NOT NULL /*版本*/
);

alter table slf_file add  constraint slf_pk primary key  (slf01,slf02,slf03,slf04,slf19) enable validate;
grant select on slf_file to tiptopgp;
grant update on slf_file to tiptopgp;
grant delete on slf_file to tiptopgp;
grant insert on slf_file to tiptopgp;
grant index on slf_file to public;
grant select on slf_file to ods;
