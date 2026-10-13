/*
================================================================================
檔案代號:tqz_file
檔案名稱:提案品项资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table tqz_file
(
tqz01       varchar2(20) NOT NULL,   /*提案单号                               */
tqz02       number(5) NOT NULL,      /*项次                                   */
tqz03       varchar2(40) NOT NULL,   /*产品编号                               */
tqz031      varchar2(120),           /*品名规格                               */
tqz04       date,                    /*促销起始日                             */
tqz05       date,                    /*促销终止日                             */
tqz06       date,                    /*进货折扣起始日                         */
tqz07       date,                    /*进货折扣终止日                         */
tqz08       varchar2(4),             /*单位                                   */
tqz09       number(20,6),            /*促销进价                               */
tqz10       varchar2(10),            /*活动方式                               */
tqz11       number(20,6),            /*促销售价                               */
tqz12       number(20,6),            /*促销毛利                               */
tqz13       number(20,6),            /*标准特售价                             */
tqz14       number(20,6),            /*标准特售毛利                           */
tqz15       number(20,6),            /*正常进价                               */
tqz16       number(20,6),            /*正常售价                               */
tqz17       number(20,6),            /*正常销售毛利                           */
tqz18       varchar2(40),            /*客户产品编号                           */
tqz19       number(15,3),            /*总目标数量                             */
tqz20       number(20,6),            /*总目标税前金额                         */
tqz21       number(20,6),            /*总目标含税金额                         */
tqzud01     varchar2(255),           /*自订字段-Textedit                      */
tqzud02     varchar2(40),            /*自订字段-文字                          */
tqzud03     varchar2(40),            /*自订字段-文字                          */
tqzud04     varchar2(40),            /*自订字段-文字                          */
tqzud05     varchar2(40),            /*自订字段-文字                          */
tqzud06     varchar2(40),            /*自订字段-文字                          */
tqzud07     number(15,3),            /*自订字段-数值                          */
tqzud08     number(15,3),            /*自订字段-数值                          */
tqzud09     number(15,3),            /*自订字段-数值                          */
tqzud10     number(10),              /*自订字段-整数                          */
tqzud11     number(10),              /*自订字段-整数                          */
tqzud12     number(10),              /*自订字段-整数                          */
tqzud13     date,                    /*自订字段-日期                          */
tqzud14     date,                    /*自订字段-日期                          */
tqzud15     date,                    /*自订字段-日期                          */
tqzplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
tqzlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index tqz_02 on tqz_file (tqz01,tqz03);
alter table tqz_file add  constraint tqz_pk primary key  (tqz01,tqz02) enable validate;
grant select on tqz_file to tiptopgp;
grant update on tqz_file to tiptopgp;
grant delete on tqz_file to tiptopgp;
grant insert on tqz_file to tiptopgp;
grant index on tqz_file to public;
grant select on tqz_file to ods;
