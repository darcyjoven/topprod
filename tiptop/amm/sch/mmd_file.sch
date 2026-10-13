/*
================================================================================
檔案代號:mmd_file
檔案名稱:模具生产系统参数档
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table mmd_file
(
mmd00       varchar2(1) NOT NULL,    /*Key Value 0                            */
mmd01       varchar2(1),             /*自制缺省结转工单否                     */
                                     /*自製預設結轉工單否                     */
mmd011      varchar2(5),             /*工单单别                               */
                                     /*工單單別                               */
mmd02       varchar2(1),             /*自制缺省结转杂收单否                   */
mmd021      varchar2(5),             /*杂收单单别                             */
                                     /*雜收單單別                             */
mmd022      varchar2(10),            /*杂收理由码                             */
                                     /*雜收理由碼                             */
mmd03       varchar2(1),             /*自制缺省结转领料单否                   */
mmd031      varchar2(5),             /*领料单单别                             */
                                     /*領料單單別                             */
mmd04       varchar2(1),             /*自制缺省结转入库单否                   */
                                     /*自製預設結轉入庫單否                   */
mmd041      varchar2(5),             /*入库单单别                             */
                                     /*入庫單單別                             */
mmd05       varchar2(1),             /*采购缺省结转请购单否                   */
                                     /*採購預設結轉請購單否                   */
mmd051      varchar2(5),             /*请购单单别                             */
                                     /*請購單單別                             */
mmd06       varchar2(1),             /*采购缺省结转采购单否                   */
                                     /*採購預設結轉採購單否                   */
mmd061      varchar2(5),             /*采购单单别                             */
                                     /*採購單單別                             */
mmd07       varchar2(1),             /*采购缺省结转收货单否                   */
                                     /*採購預設結轉收貨單否                   */
mmd071      varchar2(5),             /*收货单单别                             */
                                     /*收貨單單別                             */
mmd08       varchar2(1),             /*采购缺省结转验收单否                   */
                                     /*採購預設結轉驗收單否                   */
mmd081      varchar2(5),             /*验收单单别                             */
                                     /*驗收單單別                             */
mmd09       varchar2(1),             /*委外缺省结转工单否                     */
                                     /*委外預設結轉工單否                     */
mmd091      varchar2(5),             /*工单单别                               */
                                     /*工單單別                               */
mmd10       varchar2(1),             /*委外缺省结转采购单否                   */
                                     /*委外預設結轉採購單否                   */
mmd101      varchar2(5),             /*采购单单别                             */
                                     /*採購單單別                             */
mmd11       varchar2(1),             /*No Use                                 */
mmd111      varchar2(3),             /*No Use                                 */
mmd112      varchar2(4),             /*No Use                                 */
mmd12       varchar2(1),             /*委外缺省结转领料单否                   */
                                     /*委外預設結轉領料單否                   */
mmd121      varchar2(5),             /*领料单单别                             */
                                     /*領料單單別                             */
mmd13       varchar2(1),             /*委外缺省结转收货单否                   */
                                     /*委外預設結轉收貨單否                   */
mmd131      varchar2(5),             /*收货单单别                             */
                                     /*收貨單單別                             */
mmd14       varchar2(1),             /*委外缺省结转验收单否                   */
                                     /*委外預設結轉驗收單否                   */
mmd141      varchar2(5),             /*验收单单别                             */
                                     /*驗收單單別                             */
mmd15       number(5),               /*内制模具 工资率 元/小时                */
                                     /*內製模具 工資率 元/小時                */
mmd16       varchar2(10),            /*缺省仓库                               */
                                     /*預設倉庫 imd01                         */
mmduser     varchar2(10),            /*资料所有者                             */
                                     /*Data Owener                            */
                                     /*System Maintain                        */
mmdgrup     varchar2(10),            /*资料所有群                             */
                                     /*Data Group                             */
                                     /*System Maintain                        */
mmdmodu     varchar2(10),            /*资料更改者                             */
                                     /*Data Modified By                       */
                                     /*System Maimtain                        */
mmddate     date,                    /*最近更改日                             */
                                     /*Latest Modified Date                   */
                                     /*System Maintain                        */
mmdorig     varchar2(10),            /*资料建立部门                           */
mmdoriu     varchar2(10),            /*资料建立者                             */
mmdud01     varchar2(255),           /*自订字段                               */
mmdud02     varchar2(40),            /*自订字段                               */
mmdud03     varchar2(40),            /*自订字段                               */
mmdud04     varchar2(40),            /*自订字段                               */
mmdud05     varchar2(40),            /*自订字段                               */
mmdud06     varchar2(255),           /*自订字段                               */
mmdud07     number(15,3),            /*自订字段                               */
mmdud08     number(15,3),            /*自订字段                               */
mmdud09     number(15,3),            /*自订字段                               */
mmdud10     number(10),              /*自订字段                               */
mmdud11     number(10),              /*自订字段                               */
mmdud12     number(10),              /*自订字段                               */
mmdud13     date,                    /*自订字段                               */
mmdud14     date,                    /*自订字段                               */
mmdud15     date                     /*自订字段                               */
);

alter table mmd_file add  constraint mmd_pk primary key  (mmd00) enable validate;
grant select on mmd_file to tiptopgp;
grant update on mmd_file to tiptopgp;
grant delete on mmd_file to tiptopgp;
grant insert on mmd_file to tiptopgp;
grant index on mmd_file to public;
grant select on mmd_file to ods;
