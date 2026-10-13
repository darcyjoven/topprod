/*
================================================================================
檔案代號:aha_file
檔案名稱:常用分摊凭证单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table aha_file
(
aha00       varchar2(5) NOT NULL,    /*帐套                                   */
aha000      varchar2(1) NOT NULL,    /*性质(1)固定金额常用凭证                */
aha01       varchar2(8) NOT NULL,    /*分摊编号                               */
aha02       varchar2(6),             /*分摊类型                               */
aha03       number(5),               /*自动生成顺序                           */
aha04       date,                    /*上次生成日期                           */
aha05       date,                    /*起始生成日期                           */
aha06       date,                    /*失效日期                               */
aha07       varchar2(5),             /*总帐凭证单别                           */
aha08       varchar2(1),             /*余额来源                               */
aha09       varchar2(10),            /*预算编号                               */
aha10       varchar2(1),             /*余额性质                               */
aha11       number(20,6),            /*借方总金额或比率                       */
aha12       number(20,6),            /*贷方总金额或比率                       */
aha13       varchar2(1),             /*余额来源借贷别                         */
aha14       varchar2(20),            /*原始凭证编号                           */
aha15       varchar2(1),             /*No Use                                 */
ahamksg     varchar2(1),             /*签核否                                 */
ahasign     varchar2(4),             /*签核等级                               */
ahadays     number(5),               /*签核完成天数                           */
ahaprit     number(5),               /*签核优先等级                           */
ahaacti     varchar2(1),             /*资料有效码                             */
ahauser     varchar2(10),            /*资料所有者                             */
ahagrup     varchar2(10),            /*资料所有群                             */
ahamodu     varchar2(10),            /*资料更改者                             */
ahadate     date,                    /*最近更改日                             */
ahaud01     varchar2(255),           /*自订字段-Textedit                      */
ahaud02     varchar2(40),            /*自订字段-文字                          */
ahaud03     varchar2(40),            /*自订字段-文字                          */
ahaud04     varchar2(40),            /*自订字段-文字                          */
ahaud05     varchar2(40),            /*自订字段-文字                          */
ahaud06     varchar2(40),            /*自订字段-文字                          */
ahaud07     number(15,3),            /*自订字段-数值                          */
ahaud08     number(15,3),            /*自订字段-数值                          */
ahaud09     number(15,3),            /*自订字段-数值                          */
ahaud10     number(10),              /*自订字段-整数                          */
ahaud11     number(10),              /*自订字段-整数                          */
ahaud12     number(10),              /*自订字段-整数                          */
ahaud13     date,                    /*自订字段-日期                          */
ahaud14     date,                    /*自订字段-日期                          */
ahaud15     date,                    /*自订字段-日期                          */
ahalegal    varchar2(10) NOT NULL,   /*所属法人                               */
ahaoriu     varchar2(10),            /*资料建立者                             */
ahaorig     varchar2(10)             /*资料建立部门                           */
);

alter table aha_file add  constraint aha_pk primary key  (aha01,aha00,aha000) enable validate;
grant select on aha_file to tiptopgp;
grant update on aha_file to tiptopgp;
grant delete on aha_file to tiptopgp;
grant insert on aha_file to tiptopgp;
grant index on aha_file to public;
grant select on aha_file to ods;
