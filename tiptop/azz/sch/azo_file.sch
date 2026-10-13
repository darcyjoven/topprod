/*
================================================================================
檔案代號:azo_file
檔案名稱:系统重要资料更改记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table azo_file
(
azo01       varchar2(20),            /*程序编号                               */
                                     /*程式編號 (program code)                */
azo02       varchar2(10),            /*异动人员                               */
                                     /*異動人員                               */
azo03       date,                    /*异动日期                               */
                                     /*異動日期                               */
azo04       varchar2(10),            /*异动时间                               */
                                     /*異動時間                               */
azo05       varchar2(80),            /*异动资料的 KEY VALUE                   */
                                     /*異動資料的 KEY VALUE                   */
azo06       varchar2(80),            /*异动说明                               */
                                     /*異動說明                               */
azoplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
azolegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index azo_01 on azo_file (azo01,azo02);
create        index azo_02 on azo_file (azo04);
grant select on azo_file to tiptopgp;
grant update on azo_file to tiptopgp;
grant delete on azo_file to tiptopgp;
grant insert on azo_file to tiptopgp;
grant index on azo_file to public;
grant select on azo_file to ods;
