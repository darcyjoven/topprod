/*
================================================================================
檔案代號:sfs_file
檔案名稱:工单发料底稿单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sfs_file
(
sfs01       varchar2(20) NOT NULL,   /*发料单号                               */
                                     /*發料單號 sfp01                         */
sfs02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
sfs03       varchar2(40),            /*工单单号                               */
                                     /*Work Order   sfb01(ASR The Field Is Item#(asri210,asri220))*/
sfs04       varchar2(40),            /*料号                                   */
                                     /*料號   ima01(sfa03)                    */
sfs05       number(15,3),            /*发料数量                               */
                                     /*發料數量                               */
sfs06       varchar2(4),             /*发料单位                               */
                                     /*發料單位                               */
sfs07       varchar2(10),            /*仓库                                   */
                                     /*倉庫   imd01(img02)                    */
sfs08       varchar2(10),            /*库位                                   */
                                     /*儲位   ime01(img03)                    */
sfs09       varchar2(24),            /*批号                                   */
                                     /*批號         img04                     */
sfs10       varchar2(6),             /*作业编号                               */
                                     /*作業編號                               */
sfs21       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
sfs22       varchar2(1),             /*No Use                                 */
sfs23       varchar2(1),             /*No Use                                 */
sfs24       varchar2(1),             /*No Use                                 */
sfs25       varchar2(1),             /*No Use                                 */
sfs26       varchar2(1),             /*替代码                                 */
                                     /*替代碼 (NULL/U/S)                      */
                                     /*NULL: 非取替代件                       */
                                     /*   U: 取代料件                         */
                                     /*   S: 替代料件                         */
sfs27       varchar2(40),            /*被替代料号                             */
                                     /*被替代料號                             */
                                     /*當 sfa26=NULL   時,本欄位=發料料號     */
                                     /*當 sfa26='S/U'  時,本欄位儲存被替代料號*/
sfs28       number(15,6),            /*替代率                                 */
                                     /*當 sfa26=NULL   時,本欄位=NULL         */
                                     /*當 sfa26='S/U'  時,本欄位儲存替代率    */
sfs30       varchar2(4),             /*单位一                                 */
sfs31       number(20,8),            /*单位一换算率(与生产单位)               */
sfs32       number(15,3),            /*单位一数量                             */
sfs33       varchar2(4),             /*单位二                                 */
sfs34       number(20,8),            /*单位二换算率(与生产单位)               */
sfs35       number(15,3),            /*单位二数量                             */
sfs930      varchar2(10),            /*成本中心                               */
sfsud01     varchar2(255),           /*自订字段-Textedit                      */
sfsud02     varchar2(40),            /*原材仓                                 */
sfsud03     varchar2(40),            /*自订字段-文字                          */
sfsud04     varchar2(40),            /*自订字段-文字                          */
sfsud05     varchar2(40),            /*自订字段-文字                          */
sfsud06     varchar2(40),            /*自订字段-文字                          */
sfsud07     number(15,3),            /*批量                                   */
sfsud08     number(15,3),            /*自订字段-数值                          */
sfsud09     number(15,3),            /*自订字段-数值                          */
sfsud10     number(10),              /*自订字段-整数                          */
sfsud11     number(10),              /*自订字段-整数                          */
sfsud12     number(10),              /*自订字段-整数                          */
sfsud13     date,                    /*自订字段-日期                          */
sfsud14     date,                    /*自订字段-日期                          */
sfsud15     date,                    /*自订字段-日期                          */
sfs36       varchar2(24),            /*厂牌                                   */
sfsplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
sfslegal    varchar2(10) NOT NULL,   /*所属法人                               */
sfs012      varchar2(10),            /*工艺段号                               */
sfs013      number(5),               /*工艺序                                 */
sfs014      varchar2(23) DEFAULT ' ' NOT NULL, /*Run Card*/
sfs37       varchar2(10)             /*理由码                                 */
);

create        index sfs_03 on sfs_file (sfs04,sfs07,sfs08);
create        index sfs_02 on sfs_file (sfs03,sfs04);
alter table sfs_file add  constraint sfs_pk primary key  (sfs01,sfs02) enable validate;
grant select on sfs_file to tiptopgp;
grant update on sfs_file to tiptopgp;
grant delete on sfs_file to tiptopgp;
grant insert on sfs_file to tiptopgp;
grant index on sfs_file to public;
grant select on sfs_file to ods;
