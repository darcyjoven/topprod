/*
================================================================================
檔案代號:fbx_file
檔案名稱:资产主类别异动单单头
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fbx_file
(
fbx01       varchar2(16) DEFAULT ' ' NOT NULL, /*异动单号*/
fbx02       date,                    /*异动日期                               */
fbx03       varchar2(10),            /*申请人员                               */
fbx04       varchar2(10),            /*申请部门                               */
fbx05       date,                    /*申请日期                               */
fbx06       varchar2(1) DEFAULT '0' NOT NULL, /*状况码*/
fbx07       varchar2(20),            /*凭证编号                               */
fbx072      varchar2(20),            /*凭证编号(财签二)                       */
fbx08       date,                    /*凭证日期                               */
fbx082      date,                    /*凭证日期(财签二)                       */
fbxconf     varchar2(1) DEFAULT 'N' NOT NULL, /*确认码*/
fbxdate     date,                    /*最近更改日                             */
fbxgrup     varchar2(10),            /*资料所有部门                           */
fbxmksg     varchar2(1) DEFAULT 'N' NOT NULL, /*是否签核*/
fbxmodu     varchar2(10),            /*资料更改者                             */
fbxpost     varchar2(1) DEFAULT 'N' NOT NULL, /*过帐码*/
fbxud01     varchar2(255),           /*自订字段-Textedit                      */
fbxud02     varchar2(40),            /*自订字段-文字                          */
fbxud03     varchar2(40),            /*自订字段-文字                          */
fbxud04     varchar2(40),            /*自订字段-文字                          */
fbxud05     varchar2(40),            /*自订字段-文字                          */
fbxud06     varchar2(40),            /*自订字段-文字                          */
fbxud07     number(15,3),            /*自订字段-数值                          */
fbxud08     number(15,3),            /*自订字段-数值                          */
fbxud09     number(15,3),            /*自订字段-数值                          */
fbxud10     number(10),              /*自订字段-整数                          */
fbxud11     number(10),              /*自订字段-整数                          */
fbxud12     number(10),              /*自订字段-整数                          */
fbxud13     date,                    /*自订字段-日期                          */
fbxud14     date,                    /*自订字段-日期                          */
fbxud15     date,                    /*自订字段-日期                          */
fbxuser     varchar2(10),            /*资料所有者                             */
fbxlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
fbxorig     varchar2(10),            /*资料建立部门                           */
fbxoriu     varchar2(10)             /*资料建立者                             */
);

alter table fbx_file add  constraint fbx_pk primary key  (fbx01) enable validate;
grant select on fbx_file to tiptopgp;
grant update on fbx_file to tiptopgp;
grant delete on fbx_file to tiptopgp;
grant insert on fbx_file to tiptopgp;
grant index on fbx_file to public;
grant select on fbx_file to ods;
