/*
================================================================================
檔案代號:gal_file
檔案名稱:程序联结资料维护单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gal_file
(
gal01       varchar2(20) NOT NULL,   /*Link 程序代码                          */
                                     /*LINK程式                               */
gal02       varchar2(5) NOT NULL,    /*系统                                   */
                                     /*系統                                   */
gal03       varchar2(80) NOT NULL,   /*程序名称                               */
                                     /*程式名稱                               */
gal04       varchar2(1)              /*客制否                                 */
                                     /*是否鏈結個案區 Y/N                     */
);

alter table gal_file add  constraint gal_pk primary key  (gal01,gal02,gal03) enable validate;
grant select on gal_file to tiptopgp;
grant update on gal_file to tiptopgp;
grant delete on gal_file to tiptopgp;
grant insert on gal_file to tiptopgp;
grant index on gal_file to public;
grant select on gal_file to ods;
