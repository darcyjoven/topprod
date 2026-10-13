/*
================================================================================
檔案代號:vlc_file
檔案名稱:aps執行log檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vlc_file
(
vlc01       varchar2(10) DEFAULT ' ' NOT NULL, /*APS版本*/
vlc02       varchar2(10) DEFAULT ' ' NOT NULL, /*储存版本*/
vlc03       date,                    /*运行日期                               */
vlc04       varchar2(8),             /*运行时间                               */
vlc05       varchar2(10),            /*生成资料                               */
vlc06       varchar2(1500),          /*档案KEY值                              */
vlc07       varchar2(1500),          /*信息内容                               */
vlcplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
vlclegal    varchar2(10) NOT NULL,   /*所属法人                               */
vlc00       varchar2(1) DEFAULT '2' NOT NULL, /*类型*/
vlc08       varchar2(10),            /*信息码                                 */
vlc09       varchar2(1),             /*类型                                   */
vlc10       varchar2(20),            /*来源                                   */
vlc11       varchar2(10)             /*生成人员                               */
);

create        index vlc_02 on vlc_file (vlc00,vlc01,vlc02,vlc11);
grant select on vlc_file to tiptopgp;
grant update on vlc_file to tiptopgp;
grant delete on vlc_file to tiptopgp;
grant insert on vlc_file to tiptopgp;
grant index on vlc_file to public;
grant select on vlc_file to ods;
