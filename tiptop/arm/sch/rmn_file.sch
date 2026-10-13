/*
================================================================================
檔案代號:rmn_file
檔案名稱:客退问题审核单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rmn_file
(
rmn01       varchar2(20) NOT NULL,   /*客退问题审核文件编号                   */
                                     /*客退問題確認文件編號                   */
rmn02       varchar2(10),            /*客户编号                               */
                                     /*客戶編號                               */
rmn03       varchar2(40),            /*客户简称                               */
                                     /*客戶簡稱                               */
rmn04       varchar2(20),            /*税号                                   */
                                     /*統一編號                               */
rmn05       varchar2(20),            /*RMA单号                                */
                                     /*RMA單號                                */
rmn06       date,                    /*审核单提出日期                         */
                                     /*確認單提出日期                         */
rmn07       date,                    /*审核单回覆日期                         */
                                     /*確認單回覆日期                         */
rmnvoid     varchar2(1),             /*有效否                                 */
                                     /*有效否(Y/N)                            */
rmnconf     varchar2(1),             /*审核否                                 */
                                     /*確認否(Y/N)                            */
rmnuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
rmngrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
rmnmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
rmndate     date,                    /*最近更改日期                           */
                                     /*最近修改日期                           */
rmnud01     varchar2(255),           /*自订字段-Textedit                      */
rmnud02     varchar2(40),            /*自订字段-文字                          */
rmnud03     varchar2(40),            /*自订字段-文字                          */
rmnud04     varchar2(40),            /*自订字段-文字                          */
rmnud05     varchar2(40),            /*自订字段-文字                          */
rmnud06     varchar2(40),            /*自订字段-文字                          */
rmnud07     number(15,3),            /*自订字段-数值                          */
rmnud08     number(15,3),            /*自订字段-数值                          */
rmnud09     number(15,3),            /*自订字段-数值                          */
rmnud10     number(10),              /*自订字段-整数                          */
rmnud11     number(10),              /*自订字段-整数                          */
rmnud12     number(10),              /*自订字段-整数                          */
rmnud13     date,                    /*自订字段-日期                          */
rmnud14     date,                    /*自订字段-日期                          */
rmnud15     date,                    /*自订字段-日期                          */
rmnplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rmnlegal    varchar2(10) NOT NULL,   /*所属法人                               */
rmnoriu     varchar2(10),            /*资料建立者                             */
rmnorig     varchar2(10)             /*资料建立部门                           */
);

alter table rmn_file add  constraint rmn_pk primary key  (rmn01) enable validate;
grant select on rmn_file to tiptopgp;
grant update on rmn_file to tiptopgp;
grant delete on rmn_file to tiptopgp;
grant insert on rmn_file to tiptopgp;
grant index on rmn_file to public;
grant select on rmn_file to ods;
