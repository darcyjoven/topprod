/*
================================================================================
檔案代號:fbc_file
檔案名稱:资产调整单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fbc_file
(
fbc01       varchar2(20) NOT NULL,   /*调整单号                               */
                                     /*調整單號                               */
fbc02       date,                    /*调整日期                               */
                                     /*調整日期                               */
fbc03       varchar2(10),            /*调整原因                               */
                                     /*調整原因                               */
fbc06       varchar2(20),            /*凭证编号                               */
                                     /*傳票編號                               */
fbc07       date,                    /*凭证日期                               */
                                     /*傳票日期                               */
fbcconf     varchar2(1),             /*确认码                                 */
                                     /*確認碼(Y/N/X)                          */
fbcpost     varchar2(1),             /*过帐码                                 */
                                     /*過帳碼(Y/N)                            */
fbcpost2    varchar2(1),             /*过帐码                                 */
                                     /*過帳碼(Y/N)                            */
fbcprsw     number(5),               /*打印次数                               */
                                     /*列印次數                               */
fbcuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
fbcgrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
fbcmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
fbcdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
fbc08       varchar2(1),             /*状况码                                 */
fbcmksg     varchar2(1),             /*签核否？                               */
fbc09       varchar2(10),            /*申请人                                 */
fbcud01     varchar2(255),           /*自订字段-Textedit                      */
fbcud02     varchar2(40),            /*自订字段-文字                          */
fbcud03     varchar2(40),            /*自订字段-文字                          */
fbcud04     varchar2(40),            /*自订字段-文字                          */
fbcud05     varchar2(40),            /*自订字段-文字                          */
fbcud06     varchar2(40),            /*自订字段-文字                          */
fbcud07     number(15,3),            /*自订字段-数值                          */
fbcud08     number(15,3),            /*自订字段-数值                          */
fbcud09     number(15,3),            /*自订字段-数值                          */
fbcud10     number(10),              /*自订字段-整数                          */
fbcud11     number(10),              /*自订字段-整数                          */
fbcud12     number(10),              /*自订字段-整数                          */
fbcud13     date,                    /*自订字段-日期                          */
fbcud14     date,                    /*自订字段-日期                          */
fbcud15     date,                    /*自订字段-日期                          */
fbclegal    varchar2(10) NOT NULL,   /*所属法人                               */
fbcoriu     varchar2(10),            /*资料建立者                             */
fbcorig     varchar2(10),            /*资料建立部门                           */
fbcpost1    varchar2(1) DEFAULT 'N' NOT NULL, /*过帐码(财签二)*/
fbc062      varchar2(20),            /*传票编号(财签二)                       */
fbc072      date                     /*传票日期(财签二)                       */
);

create        index fbc_02 on fbc_file (fbc06);
alter table fbc_file add  constraint fbc_pk primary key  (fbc01) enable validate;
grant select on fbc_file to tiptopgp;
grant update on fbc_file to tiptopgp;
grant delete on fbc_file to tiptopgp;
grant insert on fbc_file to tiptopgp;
grant index on fbc_file to public;
grant select on fbc_file to ods;
