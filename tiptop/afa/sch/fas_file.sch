/*
================================================================================
檔案代號:fas_file
檔案名稱:固定资产部门转移单据单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fas_file
(
fas01       varchar2(20) NOT NULL,   /*移转单号                               */
fas02       date,                    /*移转日期                               */
fas03       varchar2(10),            /*申请人员                               */
fas04       varchar2(10),            /*申请部门                               */
fas05       date,                    /*申请日期                               */
fas06       varchar2(10),            /*原因码                                 */
fas07       varchar2(20),            /*凭证编号                               */
fas08       date,                    /*凭证日期                               */
fasconf     varchar2(1),             /*审核否                                 */
faspost     varchar2(1),             /*过帐否                                 */
fasprsw     number(5),               /*打印次数                               */
fasuser     varchar2(10),            /*资料所有者                             */
fasgrup     varchar2(10),            /*资料所有部门                           */
fasmodu     varchar2(10),            /*资料更改者                             */
fasdate     date,                    /*最近更改日                             */
fas09       varchar2(1),             /*签核状况码                             */
fasmksg     varchar2(1),             /*签核否？                               */
fasud01     varchar2(255),           /*自订字段-Textedit                      */
fasud02     varchar2(40),            /*自订字段-文字                          */
fasud03     varchar2(40),            /*自订字段-文字                          */
fasud04     varchar2(40),            /*自订字段-文字                          */
fasud05     varchar2(40),            /*自订字段-文字                          */
fasud06     varchar2(40),            /*自订字段-文字                          */
fasud07     number(15,3),            /*自订字段-数值                          */
fasud08     number(15,3),            /*自订字段-数值                          */
fasud09     number(15,3),            /*自订字段-数值                          */
fasud10     number(10),              /*自订字段-整数                          */
fasud11     number(10),              /*自订字段-整数                          */
fasud12     number(10),              /*自订字段-整数                          */
fasud13     date,                    /*自订字段-日期                          */
fasud14     date,                    /*自订字段-日期                          */
fasud15     date,                    /*自订字段-日期                          */
faslegal    varchar2(10) NOT NULL,   /*所属法人                               */
fasoriu     varchar2(10),            /*资料建立者                             */
fasorig     varchar2(10),            /*资料建立部门                           */
fas072      varchar2(20),            /*传票编号(财签二)                       */
fas082      date                     /*传票日期(财签二)                       */
);

create        index fas_02 on fas_file (fas07);
alter table fas_file add  constraint fas_pk primary key  (fas01) enable validate;
grant select on fas_file to tiptopgp;
grant update on fas_file to tiptopgp;
grant delete on fas_file to tiptopgp;
grant insert on fas_file to tiptopgp;
grant index on fas_file to public;
grant select on fas_file to ods;
