/*
================================================================================
檔案代號:cor_file
檔案名稱:材料/成品库存异动明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table cor_file
(
cor00       varchar2(1),             /*类型                                   */
cor01       varchar2(20) NOT NULL,   /*单据编号                               */
cor02       number(5) NOT NULL,      /*项次                                   */
cor03       date,                    /*单据日期                               */
cor04       varchar2(40),            /*料件编号                               */
cor05       varchar2(40),            /*商品编号                               */
cor06       varchar2(10),            /*海关编号                               */
cor07       varchar2(10),            /*厂商/客户编号                          */
cor08       varchar2(40),            /*客户简称/厂商简称                      */
cor09       number(15,3),            /*异动数量                               */
cor10       varchar2(4),             /*异动单位                               */
cor11       number(20,8),            /*转换率                                 */
cor12       number(15,3),            /*合同数量                               */
cor13       varchar2(4),             /*合同单位                               */
cor14       varchar2(1),             /*异动方式                               */
cor15       varchar2(20),            /*工单编号                               */
corconf     varchar2(1),             /*确认码                                 */
coracti     varchar2(1),             /*资料有效码                             */
coruser     varchar2(10),            /*资料所有者                             */
corgrup     varchar2(10),            /*资料所有部门                           */
cormodu     varchar2(10),            /*资料更改者                             */
cordate     date,                    /*最近更改日                             */
corud01     varchar2(255),           /*自订字段-Textedit                      */
corud02     varchar2(40),            /*自订字段-文字                          */
corud03     varchar2(40),            /*自订字段-文字                          */
corud04     varchar2(40),            /*自订字段-文字                          */
corud05     varchar2(40),            /*自订字段-文字                          */
corud06     varchar2(40),            /*自订字段-文字                          */
corud07     number(15,3),            /*自订字段-数值                          */
corud08     number(15,3),            /*自订字段-数值                          */
corud09     number(15,3),            /*自订字段-数值                          */
corud10     number(10),              /*自订字段-整数                          */
corud11     number(10),              /*自订字段-整数                          */
corud12     number(10),              /*自订字段-整数                          */
corud13     date,                    /*自订字段-日期                          */
corud14     date,                    /*自订字段-日期                          */
corud15     date,                    /*自订字段-日期                          */
corplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
corlegal    varchar2(10) NOT NULL,   /*所属法人                               */
cororig     varchar2(10),            /*资料建立部门                           */
cororiu     varchar2(10)             /*资料建立者                             */
);

alter table cor_file add  constraint cor_pk primary key  (cor01,cor02) enable validate;
grant select on cor_file to tiptopgp;
grant update on cor_file to tiptopgp;
grant delete on cor_file to tiptopgp;
grant insert on cor_file to tiptopgp;
grant index on cor_file to public;
grant select on cor_file to ods;
