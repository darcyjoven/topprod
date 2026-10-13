/*
================================================================================
檔案代號:oze_file
檔案名稱:ESC平台资讯档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table oze_file
(
oze01       varchar2(20) NOT NULL,   /*出货单                                 */
oze02       number(5) NOT NULL,      /*出货单项次                             */
oze03       number(5) NOT NULL,      /*序号                                   */
oze04       varchar2(1),             /*运输模式                               */
oze05       varchar2(30),            /*货运代码                               */
oze06       varchar2(20),            /*运输业者代码                           */
oze07       varchar2(30),            /*起运港                                 */
oze08       varchar2(30),            /*卸货港                                 */
oze09       varchar2(14),            /*到货时间                               */
oze10       varchar2(30),            /*船名                                   */
oze11       varchar2(30),            /*船次                                   */
ozeplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
ozelegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index oze_02 on oze_file (oze04,oze05,oze06,oze07,oze08);
alter table oze_file add  constraint oze_pk primary key  (oze01,oze02,oze03) enable validate;
grant select on oze_file to tiptopgp;
grant update on oze_file to tiptopgp;
grant delete on oze_file to tiptopgp;
grant insert on oze_file to tiptopgp;
grant index on oze_file to public;
grant select on oze_file to ods;
