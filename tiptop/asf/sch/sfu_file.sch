/*
================================================================================
檔案代號:sfu_file
檔案名稱:工单完工入库单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sfu_file
(
sfu00       varchar2(1),             /*类型                                   */
                                     /*1.Store-in  2.Store-In/Return 3.Re. Production Store-in*/
sfu01       varchar2(20) NOT NULL,   /*入库单号                               */
                                     /*入庫單號                               */
sfu02       date,                    /*入库日期                               */
                                     /*入庫日期                               */
sfu03       varchar2(16),            /*No Use                                 */
sfu04       varchar2(10),            /*部门                                   */
                                     /*部門     gem01                         */
sfu05       varchar2(10),            /*理由                                   */
                                     /*理由     azf01,azf02='2'               */
sfu06       varchar2(10),            /*项目编号                               */
                                     /*專案編號                               */
sfu07       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
sfu08       varchar2(20),            /*料表批号                               */
                                     /*PBI#     sfc01                         */
sfu09       varchar2(20),            /*耗材单号                               */
                                     /*耗材單號 sfp01                         */
sfu10       varchar2(1),             /*No Use                                 */
sfu11       varchar2(1),             /*No Use                                 */
sfu12       varchar2(1),             /*No Use                                 */
sfu13       varchar2(1),             /*No Use                                 */
sfupost     varchar2(1),             /*过帐否                                 */
                                     /*過帳否(Y/N/X)                          */
sfuuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
sfugrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
sfumodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
sfudate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
sfuconf     varchar2(1),             /*确认码                                 */
sfuud01     varchar2(255),           /*自订字段-Textedit                      */
sfuud02     varchar2(40),            /*自订字段-文字                          */
sfuud03     varchar2(40),            /*自订字段-文字                          */
sfuud04     varchar2(40),            /*自订字段-文字                          */
sfuud05     varchar2(40),            /*自订字段-文字                          */
sfuud06     varchar2(40),            /*自订字段-文字                          */
sfuud07     number(15,3),            /*自订字段-数值                          */
sfuud08     number(15,3),            /*自订字段-数值                          */
sfuud09     number(15,3),            /*自订字段-数值                          */
sfuud10     number(10),              /*自订字段-整数                          */
sfuud11     number(10),              /*自订字段-整数                          */
sfuud12     number(10),              /*自订字段-整数                          */
sfuud13     date,                    /*自订字段-日期                          */
sfuud14     date,                    /*自订字段-日期                          */
sfuud15     date,                    /*自订字段-日期                          */
sfu14       date,                    /*录入日期                               */
sfuplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
sfulegal    varchar2(10) NOT NULL,   /*所属法人                               */
sfuoriu     varchar2(10),            /*资料建立者                             */
sfuorig     varchar2(10),            /*资料建立部门                           */
sfu15       varchar2(1) DEFAULT '0' NOT NULL, /*签核状况*/
sfu16       varchar2(10),            /*申请人                                 */
sfumksg     varchar2(1) DEFAULT 'N' NOT NULL /*是否签核*/
);

alter table sfu_file add  constraint sfu_pk primary key  (sfu01) enable validate;
grant select on sfu_file to tiptopgp;
grant update on sfu_file to tiptopgp;
grant delete on sfu_file to tiptopgp;
grant insert on sfu_file to tiptopgp;
grant index on sfu_file to public;
grant select on sfu_file to ods;
