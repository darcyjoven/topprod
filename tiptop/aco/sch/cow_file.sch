/*
================================================================================
檔案代號:cow_file
檔案名稱:免税进口设备出口报关基本档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table cow_file
(
cow01       varchar2(30) NOT NULL,   /*预报关单号                             */
cow02       varchar2(30),            /*报关单号                               */
cow03       varchar2(20),            /*备案编号                               */
cow04       varchar2(20),            /*合同编号                               */
cow05       varchar2(20),            /*发货单位                               */
cow06       date,                    /*单据日期                               */
cow07       varchar2(20),            /*收货单位                               */
cow08       date,                    /*进口日期                               */
cow09       varchar2(6),             /*贸易性质                               */
cow10       varchar2(10),            /*贸易国家                               */
cow11       varchar2(4),             /*币种                                   */
cow12       varchar2(20),            /*通知单号                               */
cow13       number(5),               /*总件数                                 */
cow14       number(15,3),            /*总重量(公斤)                           */
cow15       varchar2(10),            /*集装箱号码                             */
cow16       varchar2(20),            /*原手册编码                             */
cowacti     varchar2(1),             /*资料有效码                             */
cowuser     varchar2(10),            /*资料所有者                             */
cowgrup     varchar2(10),            /*资料所有部门                           */
cowmodu     varchar2(10),            /*资料更改者                             */
cowdate     date,                    /*最近更改日                             */
cowud01     varchar2(255),           /*自订字段-Textedit                      */
cowud02     varchar2(40),            /*自订字段-文字                          */
cowud03     varchar2(40),            /*自订字段-文字                          */
cowud04     varchar2(40),            /*自订字段-文字                          */
cowud05     varchar2(40),            /*自订字段-文字                          */
cowud06     varchar2(40),            /*自订字段-文字                          */
cowud07     number(15,3),            /*自订字段-数值                          */
cowud08     number(15,3),            /*自订字段-数值                          */
cowud09     number(15,3),            /*自订字段-数值                          */
cowud10     number(10),              /*自订字段-整数                          */
cowud11     number(10),              /*自订字段-整数                          */
cowud12     number(10),              /*自订字段-整数                          */
cowud13     date,                    /*自订字段-日期                          */
cowud14     date,                    /*自订字段-日期                          */
cowud15     date,                    /*自订字段-日期                          */
cowplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
cowlegal    varchar2(10) NOT NULL,   /*所属法人                               */
coworig     varchar2(10),            /*资料建立部门                           */
coworiu     varchar2(10)             /*资料建立者                             */
);

alter table cow_file add  constraint cow_pk primary key  (cow01) enable validate;
grant select on cow_file to tiptopgp;
grant update on cow_file to tiptopgp;
grant delete on cow_file to tiptopgp;
grant insert on cow_file to tiptopgp;
grant index on cow_file to public;
grant select on cow_file to ods;
