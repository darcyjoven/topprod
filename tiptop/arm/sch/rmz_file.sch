/*
================================================================================
檔案代號:rmz_file
檔案名稱:RMA 参数资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table rmz_file
(
rmz01       varchar2(10),            /*RMA 仓库编号                           */
                                     /*RMA 倉庫編號-需存在於imd_file          */
rmz02       varchar2(10),            /*RMA 中途仓编号                         */
                                     /*RMA 中途倉編號-需存在於imd_file        */
rmz03       varchar2(10),            /*RMA 报废仓编号                         */
                                     /*RMA 報廢倉編號-需存在於imd_file        */
rmz04       varchar2(10),            /*RMA 不良品仓编号                       */
                                     /*RMA 不良品倉編號-需存在於imd_file      */
rmz05       varchar2(5),             /*缺省RMA 单别                           */
                                     /*預設RMA 單別                           */
rmz06       varchar2(5),             /*缺省RMA 覆出单别                       */
                                     /*預設RMA 覆出單別                       */
rmz07       varchar2(5),             /*缺省RMA 发料单单别                     */
                                     /*預設RMA 發料單單別                     */
rmz08       varchar2(5),             /*缺省RMA 收料单单别                     */
                                     /*預設RMA 收料單單別                     */
rmz09       varchar2(3),             /*No Use                                 */
rmz10       varchar2(3),             /*No Use                                 */
rmz11       varchar2(5),             /*缺省RMA 应收帐款立帐单单别             */
                                     /*預設RMA 應收帳款立帳單單別             */
rmz12       number(5),               /*RMA仓盘点资料转入发料单单身            */
                                     /*RMA倉盤點資料轉入發料單單身筆數        */
rmz13       varchar2(10),            /*RMA仓盘点资料转入发料单部门            */
                                     /*RMA倉盤點資料轉入發料單部門編號        */
rmz14       varchar2(10),            /*RMA仓盘点资料转入发料单理由            */
                                     /*RMA倉盤點資料轉入發料單理由碼          */
rmz15       varchar2(1),             /*RMA覆出单应收帐款使用汇率别            */
                                     /*RMA覆出單應收帳款使用匯率別            */
rmz16       varchar2(5),             /*缺省调拨单单别                         */
                                     /*預設調撥單單別                         */
rmz17       varchar2(5),             /*缺省客修审核单单别                     */
                                     /*預設客修確認單單別                     */
rmz18       varchar2(5),             /*缺省报废单单别                         */
                                     /*預設報廢單單別                         */
rmz19       varchar2(1),             /*内销是否自动收单审核                   */
                                     /*内销是否自动收单审核(Y/N) NO:7138add养生*/
rmz20       number(5),               /*覆出工作天数                           */
                                     /*覆出工作天數              NO:7138add養生*/
rmz21       number(5),               /*RMA应收利润率                          */
                                     /*RMA應收利潤率             NO:7138add養生*/
rmz00       varchar2(1) DEFAULT '0' NOT NULL, /*KEY VALUE*/
rmzud01     varchar2(255),           /*自订字段                               */
rmzud02     varchar2(40),            /*自订字段                               */
rmzud03     varchar2(40),            /*自订字段                               */
rmzud04     varchar2(40),            /*自订字段                               */
rmzud05     varchar2(40),            /*自订字段                               */
rmzud06     varchar2(255),           /*自订字段                               */
rmzud07     number(15,3),            /*自订字段                               */
rmzud08     number(15,3),            /*自订字段                               */
rmzud09     number(15,3),            /*自订字段                               */
rmzud10     number(10),              /*自订字段                               */
rmzud11     number(10),              /*自订字段                               */
rmzud12     number(10),              /*自订字段                               */
rmzud13     date,                    /*自订字段                               */
rmzud14     date,                    /*自订字段                               */
rmzud15     date                     /*自订字段                               */
);

alter table rmz_file add  constraint rmz_pk primary key  (rmz00) enable validate;
grant select on rmz_file to tiptopgp;
grant update on rmz_file to tiptopgp;
grant delete on rmz_file to tiptopgp;
grant insert on rmz_file to tiptopgp;
grant index on rmz_file to public;
grant select on rmz_file to ods;
