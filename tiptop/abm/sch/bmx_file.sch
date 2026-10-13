/*
================================================================================
檔案代號:bmx_file
檔案名稱:ECN 单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table bmx_file
(
bmx01       varchar2(20) NOT NULL,   /*ECN 单号                               */
                                     /*ECN 單號                               */
bmx02       date,                    /*录入日期                               */
                                     /*輸入日期                               */
bmx03       varchar2(20),            /*No Use                                 */
bmx04       varchar2(1),             /*审核否                                 */
                                     /*確認否(Y/N)                            */
                                     /*N: 未更新 BOM                          */
                                     /*Y: 已更新 BOM                          */
                                     /*X: 作廢                                */
bmx05       varchar2(20),            /*ECR NO                                 */
bmx06       varchar2(2),             /*资料类型                               */
bmx07       date,                    /*ECN 生效日期                           */
bmx08       date,                    /*失效日期                               */
bmxuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
bmxgrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
bmxmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
bmxdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
bmxacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
bmx09       varchar2(1),             /*状况码                                 */
bmxmksg     varchar2(1),             /*签核                                   */
bmx10       varchar2(10),            /*申请人                                 */
bmx11       varchar2(10) DEFAULT ' ' NOT NULL, /*资料来源*/
bmx12       number(10),              /*抛转次数                               */
bmxplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
bmxlegal    varchar2(10) NOT NULL,   /*所属法人                               */
bmxoriu     varchar2(10),            /*资料建立者                             */
bmxorig     varchar2(10),            /*资料建立部门                           */
bmx13       varchar2(10),            /*申请部门                               */
bmx50       varchar2(1)              /*BOM类别                                */
);

create        index bmx_02 on bmx_file (bmx02);
alter table bmx_file add  constraint bmx_pk primary key  (bmx01) enable validate;
grant select on bmx_file to tiptopgp;
grant update on bmx_file to tiptopgp;
grant delete on bmx_file to tiptopgp;
grant insert on bmx_file to tiptopgp;
grant index on bmx_file to public;
grant select on bmx_file to ods;
