/*
================================================================================
檔案代號:coc_file
檔案名稱:合同基本资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table coc_file
(
coc01       varchar2(20) NOT NULL,   /*申请编号                               */
coc02       varchar2(4),             /*币种                                   */
coc03       varchar2(20),            /*手册编号                               */
coc04       varchar2(20),            /*合同编号                               */
coc05       date,                    /*有效期限                               */
coc06       date,                    /*审批日期                               */
coc07       date,                    /*核销日期                               */
coc08       number(20,6),            /*进口总值                               */
coc09       number(20,6),            /*出口总值                               */
coc10       varchar2(10),            /*海关编号                               */
coc11       varchar2(1),             /*No Use                                 */
coc12       varchar2(1),             /*No Use                                 */
cocacti     varchar2(1),             /*资料有效码                             */
cocuser     varchar2(10),            /*资料所有者                             */
cocgrup     varchar2(10),            /*资料所有群                             */
cocmodu     varchar2(10),            /*资料更改者                             */
cocdate     date,                    /*最近更改日                             */
cocud01     varchar2(255),           /*自订字段-Textedit                      */
cocud02     varchar2(40),            /*自订字段-文字                          */
cocud03     varchar2(40),            /*自订字段-文字                          */
cocud04     varchar2(40),            /*自订字段-文字                          */
cocud05     varchar2(40),            /*自订字段-文字                          */
cocud06     varchar2(40),            /*自订字段-文字                          */
cocud07     number(15,3),            /*自订字段-数值                          */
cocud08     number(15,3),            /*自订字段-数值                          */
cocud09     number(15,3),            /*自订字段-数值                          */
cocud10     number(10),              /*自订字段-整数                          */
cocud11     number(10),              /*自订字段-整数                          */
cocud12     number(10),              /*自订字段-整数                          */
cocud13     date,                    /*自订字段-日期                          */
cocud14     date,                    /*自订字段-日期                          */
cocud15     date,                    /*自订字段-日期                          */
cocplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
coclegal    varchar2(10) NOT NULL,   /*所属法人                               */
cocorig     varchar2(10),            /*资料建立部门                           */
cocoriu     varchar2(10)             /*资料建立者                             */
);

create        index coc_02 on coc_file (coc03,coc10);
alter table coc_file add  constraint coc_pk primary key  (coc01) enable validate;
grant select on coc_file to tiptopgp;
grant update on coc_file to tiptopgp;
grant delete on coc_file to tiptopgp;
grant insert on coc_file to tiptopgp;
grant index on coc_file to public;
grant select on coc_file to ods;
