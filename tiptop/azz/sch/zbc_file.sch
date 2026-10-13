/*
================================================================================
檔案代號:zbc_file
檔案名稱:USER需求处理单档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table zbc_file
(
zbc01       varchar2(20) NOT NULL,   /*单号                                   */
                                     /*單號                                   */
zbc02       date,                    /*反应日期                               */
                                     /*反應日期                               */
zbc03       varchar2(10),            /*反应者                                 */
                                     /*反應者                                 */
zbc04       varchar2(20),            /*程序编号                               */
                                     /*程式代號                               */
zbc051      varchar2(80),            /*需求描述-1                             */
zbc052      varchar2(80),            /*需求描述-2                             */
zbc053      varchar2(80),            /*需求描述-3                             */
zbc054      varchar2(80),            /*需求描述-4                             */
zbc055      varchar2(80),            /*需求描述-5                             */
zbc06       varchar2(1),             /*分类                                   */
                                     /*分類                                   */
                                     /*1.Bug 2.需求                           */
zbc11       date,                    /*MIS接收日                              */
zbc12       varchar2(10),            /*MIS接收人员                            */
                                     /*MIS接收人員                            */
zbc13       varchar2(1),             /*处理对象                               */
                                     /*處理對象                               */
                                     /*1.MIS  2.DSC 3.Hold 4.Reject           */
zbc14       varchar2(10),            /*MIS处理人员                            */
                                     /*MIS處理人員                            */
zbc15       varchar2(1),             /*通知DSC方式                            */
                                     /*通知DSC方式   (zbc13='2'時輸入)        */
                                     /*1.Mail 2.Fax                           */
zbc16       date,                    /*通知DSC 日期                           */
zbc17       date,                    /*DSC回覆日                              */
zbc18       varchar2(1),             /*MIS回覆注记                            */
                                     /*MIS回覆註記                            */
                                     /*1.同意DSC處理 2.改由MIS處理            */
                                     /*3.另立需求單處理                       */
                                     /*4.Hold  5.Reject                       */
zbc19       date,                    /*MIS回覆注记日期                        */
                                     /*MIS回覆註記日期                        */
zbc20       varchar2(10),            /*MIS回覆注记人员                        */
                                     /*MIS回覆註記人員                        */
zbc21       date,                    /*预计完成日                             */
                                     /*預計完成日                             */
zbc22       date,                    /*实际完成日                             */
                                     /*實際完成日                             */
zbc23       varchar2(1),             /*当前状态                               */
                                     /*目前狀態                               */
                                     /*1.open 2.mis接收中 3.通知dsc中 4.DSC回覆*/
                                     /*5.mis處理中 6.dsc處理中 7.己完成 8.Hold*/
                                     /*9.Reject A.結案 B.已驗收               */
zbc24       date,                    /*反应者验收日                           */
                                     /*反應者驗收日                           */
zbc25       varchar2(10),            /*验收人员                               */
                                     /*驗收人員                               */
zbc26       date,                    /*当前状态更新日期                       */
                                     /*目前狀態更新日期                       */
zbc301      varchar2(80),            /*处理说明-1                             */
                                     /*處理說明-1                             */
zbc302      varchar2(80),            /*处理说明-2                             */
                                     /*處理說明-2                             */
zbc303      varchar2(80),            /*处理说明-3                             */
                                     /*處理說明-3                             */
zbc304      varchar2(80),            /*处理说明-4                             */
                                     /*處理說明-4                             */
zbc305      varchar2(80),            /*处理说明-5                             */
                                     /*處理說明-5                             */
zbcuser     varchar2(10),            /*OWNER                                  */
zbcgrup     varchar2(10),            /*GROUP                                  */
zbcmodu     varchar2(10),            /*MODIFY USER                            */
zbcdate     date,                    /*MODIFY DATE                            */
zbcorig     varchar2(10),            /*资料建立部门                           */
zbcoriu     varchar2(10)             /*资料建立者                             */
);

create        index zbc_03 on zbc_file (zbc03);
create        index zbc_02 on zbc_file (zbc02);
alter table zbc_file add  constraint zbc_pk primary key  (zbc01) enable validate;
grant select on zbc_file to tiptopgp;
grant update on zbc_file to tiptopgp;
grant delete on zbc_file to tiptopgp;
grant insert on zbc_file to tiptopgp;
grant index on zbc_file to public;
grant select on zbc_file to ods;
