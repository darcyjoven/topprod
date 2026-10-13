/*
================================================================================
檔案代號:fab_file
檔案名稱:固定资产主要类型档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table fab_file
(
fab01       varchar2(10) NOT NULL,   /*资产主要类型                           */
fab02       varchar2(80),            /*类型名称                               */
fab03       varchar2(1),             /*资产性质                               */
fab04       varchar2(1),             /*折旧方法                               */
fab05       number(5),               /*耐用年限(月数)                         */
fab06       varchar2(1),             /*税签折旧方法                           */
fab07       number(5),               /*税签耐用年限                           */
fab08       varchar2(1),             /*折毕再提否                             */
fab09       number(11),              /*No Use                                 */
fab10       number(5),               /*折毕再提年限                           */
fab11       varchar2(24),            /*资产会计科目                           */
fab12       varchar2(24),            /*累计折旧会计科目                       */
fab13       varchar2(24),            /*折旧费用会计科目                       */
fab14       varchar2(1),             /*是否直接资本化                         */
fab15       varchar2(1),             /*保税否                                 */
fab16       varchar2(1),             /*保险否                                 */
fab17       varchar2(1),             /*免税否                                 */
fab18       varchar2(1),             /*抵押否                                 */
fab19       varchar2(1),             /*投资抵减否                             */
fab20       number(5),               /*本币投资抵减比率                       */
fab21       number(5),               /*外币投资抵减比率                       */
fab22       number(5),               /*投资抵减补税年限                       */
fab23       number(5),               /*残值率                                 */
fabacti     varchar2(1),             /*资料有效码                             */
fabuser     varchar2(10),            /*资料所有者                             */
fabgrup     varchar2(10),            /*资料所有群                             */
fabmodu     varchar2(10),            /*资料更改者                             */
fabdate     date,                    /*最近更改日                             */
fab24       varchar2(24),            /*减值准备科目                           */
fab25       varchar2(1),             /*No Use                                 */
fab26       varchar2(1),             /*No Use                                 */
fab27       varchar2(1),             /*No Use                                 */
fab28       number(5),               /*No Use                                 */
fab29       number(5),               /*No Use                                 */
fab111      varchar2(24),            /*资产会计科目二                         */
fab121      varchar2(24),            /*累计折旧会计科目二                     */
fab131      varchar2(24),            /*折旧费用会计科目二                     */
fab241      varchar2(24),            /*减值准备科目二                         */
fabud01     varchar2(255),           /*自订字段-Textedit                      */
fabud02     varchar2(40),            /*自订字段-文字                          */
fabud03     varchar2(40),            /*自订字段-文字                          */
fabud04     varchar2(40),            /*自订字段-文字                          */
fabud05     varchar2(40),            /*自订字段-文字                          */
fabud06     varchar2(40),            /*自订字段-文字                          */
fabud07     number(15,3),            /*自订字段-数值                          */
fabud08     number(15,3),            /*自订字段-数值                          */
fabud09     number(15,3),            /*自订字段-数值                          */
fabud10     number(10),              /*自订字段-整数                          */
fabud11     number(10),              /*自订字段-整数                          */
fabud12     number(10),              /*自订字段-整数                          */
fabud13     date,                    /*自订字段-日期                          */
fabud14     date,                    /*自订字段-日期                          */
fabud15     date,                    /*自订字段-日期                          */
faboriu     varchar2(10),            /*资料建立者                             */
faborig     varchar2(10),            /*资料建立部门                           */
fab042      varchar2(1) DEFAULT '1' NOT NULL, /*折旧方法(财签二)*/
fab052      number(5),               /*耐用年限(月数)(财签二)                 */
fab082      varchar2(1) DEFAULT 'N' NOT NULL, /*折毕再提否(财签二)*/
fab232      number(5),               /*残值率(财签二)                         */
fab102      number(5)                /*折毕再提年限(财签二)                   */
);

alter table fab_file add  constraint fab_pk primary key  (fab01) enable validate;
grant select on fab_file to tiptopgp;
grant update on fab_file to tiptopgp;
grant delete on fab_file to tiptopgp;
grant insert on fab_file to tiptopgp;
grant index on fab_file to public;
grant select on fab_file to ods;
