/*
================================================================================
檔案代號:smi_file
檔案名稱:制造管理系统―系统关闭记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table smi_file
(
smi01       varchar2(10) DEFAULT ' ' NOT NULL, /*操作人员*/
                                     /*操作人員                               */
smi02       varchar2(20) DEFAULT ' ' NOT NULL, /*程序编号*/
                                     /*程式編號                               */
smi03       date DEFAULT sysdate NOT NULL, /*系统日期*/
                                     /*系統日期                               */
smi04       varchar2(8) DEFAULT ' ' NOT NULL, /*系统时间*/
                                     /*系統時間                               */
smi05       varchar2(16),            /*终端机编号                             */
                                     /*終端機編號                             */
smi06       varchar2(255),           /*备注(一)                               */
                                     /*備註(一)                               */
smi07       varchar2(255),           /*备注(二)                               */
                                     /*no use                            genero*/
smi08       varchar2(255),           /*备注(三)                               */
                                     /*no use                            genero*/
smiplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
smilegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table smi_file add  constraint smi_pk primary key  (smi01,smi02,smi03,smi04) enable validate;
grant select on smi_file to tiptopgp;
grant update on smi_file to tiptopgp;
grant delete on smi_file to tiptopgp;
grant insert on smi_file to tiptopgp;
grant index on smi_file to public;
grant select on smi_file to ods;
