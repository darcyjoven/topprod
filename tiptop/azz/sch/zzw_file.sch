/*
================================================================================
檔案代號:zzw_file
檔案名稱:报表输出格式参数设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zzw_file
(
zzw01       varchar2(20) NOT NULL,   /*程序编号                               */
                                     /*程式代號, (program code)               */
                                     /* Ex:pka0203 , pkb0218                  */
zzw02       varchar2(255),           /*报表字段参数                           */
                                     /*報表欄位參數                           */
zzw03       varchar2(1),             /*是否直接生成图表                       */
                                     /*是否直接產生圖表                       */
zzw04       varchar2(2),             /*图表X轴资料来源字段位置                */
                                     /*圖表X軸資料來源欄位位置                */
zzw05       varchar2(2),             /*图表Y轴资料来源字段位置                */
                                     /*圖表Y軸資料來源欄位位置                */
zzw06       varchar2(2),             /*图表Z轴资料来源字段位置                */
                                     /*圖表Z軸資料來源欄位位置                */
zzw07       varchar2(3),             /*图表缺省图形编号                       */
                                     /*圖表預設圖形代號                       */
zzw08       varchar2(2)              /*图表区缺省字形大小                     */
                                     /*圖表區預設字形大小                     */
);

alter table zzw_file add  constraint zzw_pk primary key  (zzw01) enable validate;
grant select on zzw_file to tiptopgp;
grant update on zzw_file to tiptopgp;
grant delete on zzw_file to tiptopgp;
grant insert on zzw_file to tiptopgp;
grant index on zzw_file to public;
grant select on zzw_file to ods;
