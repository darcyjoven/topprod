/*
================================================================================
檔案代號:mml_file
檔案名稱:零件加工额外领料底稿档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table mml_file
(
mml01       varchar2(20) NOT NULL,   /*需求单号                               */
                                     /*需求單號 mmb01                         */
mml02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次     mmb02                         */
mml021      number(5) NOT NULL,      /*额外领料项次                           */
                                     /*額外領料項次                           */
mml03       varchar2(10),            /*No Use                                 */
mml04       varchar2(40),            /*料号                                   */
                                     /*料號   ima01                           */
mml05       number(15,3),            /*发料数量                               */
                                     /*發料數量                               */
mml06       varchar2(4),             /*发料单位                               */
                                     /*發料單位                               */
mml07       varchar2(10),            /*仓库                                   */
                                     /*倉庫   imd01(img02)                    */
mml08       varchar2(10),            /*库位                                   */
                                     /*儲位   ime01(img03)                    */
mml09       varchar2(24),            /*批号                                   */
                                     /*批號         img04                     */
mml10       varchar2(6),             /*No Use                                 */
mml21       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
mml22       varchar2(1),             /*No Use                                 */
mml23       varchar2(1),             /*No Use                                 */
mml24       varchar2(1),             /*No Use                                 */
mml25       varchar2(1),             /*No Use                                 */
mml26       varchar2(1),             /*No Use                                 */
mml27       varchar2(20),            /*No Use                                 */
mml28       number(6,3),             /*No Use                                 */
mmlud01     varchar2(255),           /*自订字段-Textedit                      */
mmlud02     varchar2(40),            /*自订字段-文字                          */
mmlud03     varchar2(40),            /*自订字段-文字                          */
mmlud04     varchar2(40),            /*自订字段-文字                          */
mmlud05     varchar2(40),            /*自订字段-文字                          */
mmlud06     varchar2(40),            /*自订字段-文字                          */
mmlud07     number(15,3),            /*自订字段-数值                          */
mmlud08     number(15,3),            /*自订字段-数值                          */
mmlud09     number(15,3),            /*自订字段-数值                          */
mmlud10     number(10),              /*自订字段-整数                          */
mmlud11     number(10),              /*自订字段-整数                          */
mmlud12     number(10),              /*自订字段-整数                          */
mmlud13     date,                    /*自订字段-日期                          */
mmlud14     date,                    /*自订字段-日期                          */
mmlud15     date,                    /*自订字段-日期                          */
mmlplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
mmllegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table mml_file add  constraint mml_pk primary key  (mml01,mml02,mml021) enable validate;
grant select on mml_file to tiptopgp;
grant update on mml_file to tiptopgp;
grant delete on mml_file to tiptopgp;
grant insert on mml_file to tiptopgp;
grant index on mml_file to public;
grant select on mml_file to ods;
