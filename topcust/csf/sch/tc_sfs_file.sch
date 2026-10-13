/*
================================================================================
檔案代號:tc_sfs_file
檔案名稱:委外采购发料单单身
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_sfs_file
(
tc_sfs01    varchar2(20) NOT NULL,   /*工艺委外发料单单号                     */
tc_sfs02    number(5) NOT NULL,      /*项次                                   */
tc_sfs03    varchar2(40),            /*料号                                   */
tc_sfs04    number(15,3),            /*应发数量                               */
tc_sfs05    number(15,3),            /*实发数量                               */
tc_sfs06    varchar2(4),             /*发料单位                               */
tc_sfsud01  varchar2(255),           /*自订栏位-Textedit                      */
tc_sfsud02  varchar2(40),            /*自订栏位-文字                          */
tc_sfsud03  varchar2(40),            /*自订栏位-文字                          */
tc_sfsud04  varchar2(40),            /*自订栏位-文字                          */
tc_sfsud05  varchar2(40),            /*自订栏位-文字                          */
tc_sfsud06  varchar2(40),            /*自订栏位-文字                          */
tc_sfsud07  number(15,3),            /*自订栏位-数值                          */
tc_sfsud08  number(15,3),            /*自订栏位-数值                          */
tc_sfsud09  number(15,3),            /*自订栏位-数值                          */
tc_sfsud10  number(10),              /*自订栏位-整数                          */
tc_sfsud11  number(10),              /*自订栏位-整数                          */
tc_sfsud12  number(10),              /*自订栏位-整数                          */
tc_sfsud13  date,                    /*自订栏位-日期                          */
tc_sfsud14  date,                    /*自订栏位-日期                          */
tc_sfsud15  date,                    /*自订栏位-日期                          */
tc_sfsplant varchar2(10),            /*所属营运中心                           */
tc_sfslegal varchar2(10)             /*所属法人                               */
);

alter table tc_sfs_file add  constraint tc_sfs_pk primary key  (tc_sfs01,tc_sfs02) enable validate;
grant select on tc_sfs_file to tiptopgp;
grant update on tc_sfs_file to tiptopgp;
grant delete on tc_sfs_file to tiptopgp;
grant insert on tc_sfs_file to tiptopgp;
grant index on tc_sfs_file to public;
grant select on tc_sfs_file to ods;
