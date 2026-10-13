/*
================================================================================
檔案代號:smj_file
檔案名稱:制造管理系统―系统[关闭/开启]历史记
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table smj_file
(
smj01       varchar2(10),            /*操作人员―系统关闭记录                  */
                                     /*操作人員－系統關閉記錄                 */
smj02       varchar2(20),            /*程序编号                               */
                                     /*程式編號                               */
smj03       date,                    /*系统日期                               */
                                     /*系統日期                               */
smj04       varchar2(8),             /*系统时间                               */
                                     /*系統時間                               */
smj05       varchar2(16),            /*终端机编号                             */
                                     /*終端機編號                             */
smj06       varchar2(255),           /*备注(一)                               */
                                     /*備註(一)                               */
smj07       varchar2(255),           /*备注(二)                               */
                                     /*no use                            genero*/
smj08       varchar2(255),           /*备注(三)                               */
                                     /*no use                            genero*/
smj09       varchar2(10),            /*操作人员―系统开启记录                  */
                                     /*操作人員－系統開啟記錄                 */
smj10       varchar2(20),            /*程序编号                               */
                                     /*程式編號                               */
smj11       date,                    /*系统日期                               */
                                     /*系統日期                               */
smj12       varchar2(8),             /*系统时间                               */
                                     /*系統時間                               */
smj13       varchar2(16),            /*终端机编号                             */
                                     /*終端機編號                             */
smj14       varchar2(255),           /*备注(一)                               */
                                     /*備註(一)                               */
smj15       varchar2(255),           /*备注(二)                               */
                                     /*no use                            genero*/
smj16       varchar2(255),           /*备注(三)                               */
                                     /*no use                            genero*/
smjplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
smjlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

grant select on smj_file to tiptopgp;
grant update on smj_file to tiptopgp;
grant delete on smj_file to tiptopgp;
grant insert on smj_file to tiptopgp;
grant index on smj_file to public;
grant select on smj_file to ods;
