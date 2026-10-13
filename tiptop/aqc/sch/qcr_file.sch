/*
================================================================================
檔案代號:qcr_file
檔案名稱:质量异常单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table qcr_file
(
qcr01       varchar2(20) NOT NULL,   /*质量异常单单号                         */
qcr02       date,                    /*单据日期                               */
qcr03       varchar2(10),            /*申请单位                               */
qcr04       varchar2(10),            /*申请人员                               */
qcr05       varchar2(40),            /*料号                                   */
qcr06       number(15,3),            /*不良数量                               */
qcr07       varchar2(10),            /*单位                                   */
qcr08       varchar2(10),            /*责任归属                               */
qcr09       varchar2(10),            /*厂商/部门代码                          */
qcr10       varchar2(1),             /*判定                                   */
qcr11       number(15,3),            /*处理质量异常成本                       */
qcr12       number(20,6),            /*扣款金额                               */
qcrconf     varchar2(1),             /*审核否                                 */
qcrdate     date,                    /*最近更改日                             */
qcrgrup     varchar2(10),            /*资料所有部门                           */
qcrmodu     varchar2(10),            /*资料更改者                             */
qcruser     varchar2(10),            /*资料所有者                             */
qcr13       varchar2(20),            /*参考单号                               */
qcrud01     varchar2(255),           /*自订字段-Textedit                      */
qcrud02     varchar2(40),            /*自订字段-文字                          */
qcrud03     varchar2(40),            /*自订字段-文字                          */
qcrud04     varchar2(40),            /*自订字段-文字                          */
qcrud05     varchar2(40),            /*自订字段-文字                          */
qcrud06     varchar2(40),            /*自订字段-文字                          */
qcrud07     number(15,3),            /*自订字段-数值                          */
qcrud08     number(15,3),            /*自订字段-数值                          */
qcrud09     number(15,3),            /*自订字段-数值                          */
qcrud10     number(10),              /*自订字段-整数                          */
qcrud11     number(10),              /*自订字段-整数                          */
qcrud12     number(10),              /*自订字段-整数                          */
qcrud13     date,                    /*自订字段-日期                          */
qcrud14     date,                    /*自订字段-日期                          */
qcrud15     date,                    /*自订字段-日期                          */
qcrplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
qcrlegal    varchar2(10) NOT NULL,   /*所属法人                               */
qcroriu     varchar2(10),            /*资料建立者                             */
qcrorig     varchar2(10)             /*资料建立部门                           */
);

alter table qcr_file add  constraint qcr_pk primary key  (qcr01) enable validate;
grant select on qcr_file to tiptopgp;
grant update on qcr_file to tiptopgp;
grant delete on qcr_file to tiptopgp;
grant insert on qcr_file to tiptopgp;
grant index on qcr_file to public;
grant select on qcr_file to ods;
