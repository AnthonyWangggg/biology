/*
 Navicat MySQL Data Transfer

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80021
 Source Host           : localhost:3306
 Source Schema         : biotoolsdb

 Target Server Type    : MySQL
 Target Server Version : 80021
 File Encoding         : 65001

 Date: 09/06/2021 22:12:47
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for history
-- ----------------------------
DROP TABLE IF EXISTS `history`;
CREATE TABLE `history`  (
  `HISTORYID` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `DATAPATH` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `DATANAME` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `PICPATH` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `PICNAME` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `EMAIL` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `MODEL` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `TOOLFUNCTION` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`HISTORYID`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of history
-- ----------------------------
INSERT INTO `history` VALUES ('0017HnE20210609215052FaR0', 'UploadFolder/001@qq.com/', '20210609215052_saliency2.txt', 'UserFolder/001@qq.com/', '20210609215052_saliency2.svg', '001@qq.com', 'StatisticalAnalysis', 'bartest2');
INSERT INTO `history` VALUES ('001aJ4t20210609214550w5oc', 'UploadFolder/001@qq.com/', '20210609214550_saliency2.txt', 'UserFolder/001@qq.com/', '20210609214550_saliency2.svg', '001@qq.com', 'StatisticalAnalysis', 'saliency2');
INSERT INTO `history` VALUES ('001GSeM20210609213332jdVu', 'UploadFolder/001@qq.com/', '20210609213332_tsne.txt', 'UserFolder/001@qq.com/', '20210609213332_tsne.svg,20210609213332_tsne.txt', '001@qq.com', 'ClusteringAnalysis', 'tsne_chart');
INSERT INTO `history` VALUES ('001koWH20210609213553Db2s', 'UploadFolder/001@qq.com/', '20210609213553_tsne_out.txt', 'UserFolder/001@qq.com/', '20210609213553_tsne.svg,20210609213553_tsne.txt', '001@qq.com', 'ClusteringAnalysis', 'tsne_chart');
INSERT INTO `history` VALUES ('001oXuv20210609212136UnlH', 'UploadFolder/001@qq.com/', '20210609212136_nmds_out.txt,20210609212136_nmds_group.txt', 'UserFolder/001@qq.com/', '20210609212136_nmds.svg', '001@qq.com', 'ClusteringAnalysis', 'NMDS');
INSERT INTO `history` VALUES ('001rcbA20210609215509idQB', 'UploadFolder/001@qq.com/', '20210609215509_saliency2.txt', 'UserFolder/001@qq.com/', '20210609215510_saliency2.svg', '001@qq.com', 'StatisticalAnalysis', 'bartest2');
INSERT INTO `history` VALUES ('001sHXX202106092136126JKw', 'UploadFolder/001@qq.com/', '20210609213612_tsne.txt', 'UserFolder/001@qq.com/', '20210609213612_tsne.svg,20210609213612_tsne.txt', '001@qq.com', 'ClusteringAnalysis', 'tsne_chart');
INSERT INTO `history` VALUES ('001wpYZ202106092124363QTD', 'UploadFolder/001@qq.com/', '20210609212436_pcoa_out.txt,20210609212436_pcoa_group.txt', 'UserFolder/001@qq.com/', '20210609212436_pcoa.svg', '001@qq.com', 'ClusteringAnalysis', 'PCOA');
INSERT INTO `history` VALUES ('001wZQ720210609215004XUpZ', 'UploadFolder/001@qq.com/', '20210609215004_multisaliency.txt', 'UserFolder/001@qq.com/', '20210609215004_multisaliency.svg', '001@qq.com', 'StatisticalAnalysis', 'multisaliency');
INSERT INTO `history` VALUES ('001ypZo20210609215033q5Pc', 'UploadFolder/001@qq.com/', '20210609215033_multisaliency.txt', 'UserFolder/001@qq.com/', '20210609215033_multisaliency.svg', '001@qq.com', 'StatisticalAnalysis', 'multibar');
INSERT INTO `history` VALUES ('001Z9rQ20210609213345RxbJ', 'UploadFolder/001@qq.com/', '20210609213345_tsne_out.txt', 'UserFolder/001@qq.com/', '20210609213345_tsne.svg,20210609213345_tsne.txt', '001@qq.com', 'ClusteringAnalysis', 'tsne_chart');
INSERT INTO `history` VALUES ('1792802452HGXU20210521140059LFpN', 'UploadFolder/1792802452@qq.com/', '20210521140059_heatmap.rpkm.txt', 'UserFolder/1792802452@qq.com/', '20210521140059_heatmap.svg', '1792802452@qq.com', 'BaseFunction', 'heatmap');
INSERT INTO `history` VALUES ('1792802452K5ds20210521140220ab83', 'UploadFolder/1792802452@qq.com/', '20210521140220_heatmap.rpkm.txt', 'UserFolder/1792802452@qq.com/', '20210521140220_heatmap.svg', '1792802452@qq.com', 'BaseFunction', 'heatmap');
INSERT INTO `history` VALUES ('1792802452LpYL20210521135149uPsj', 'UploadFolder/1792802452@qq.com/', '20210521135149_heatmap.rpkm.txt', 'UserFolder/1792802452@qq.com/', '20210521135149_heatmap.svg', '1792802452@qq.com', 'BaseFunction', 'heatmap');
INSERT INTO `history` VALUES ('1792802452nVZK202105211401391gSQ', 'UploadFolder/1792802452@qq.com/', '20210521140139_heatmap.rpkm.txt', 'UserFolder/1792802452@qq.com/', '20210521140139_heatmap.svg', '1792802452@qq.com', 'BaseFunction', 'heatmap');
INSERT INTO `history` VALUES ('1792802452ODZa20210521134505i42e', 'UploadFolder/1792802452@qq.com/', '20210521134505_heatmap.rpkm.txt', 'UserFolder/1792802452@qq.com/', '20210521134505_heatmap.svg', '1792802452@qq.com', 'BaseFunction', 'heatmap');
INSERT INTO `history` VALUES ('1792802452ozUh202105211352047YFt', 'UploadFolder/1792802452@qq.com/', '20210521135204_heatmap.rpkm.txt', 'UserFolder/1792802452@qq.com/', '20210521135204_heatmap.svg', '1792802452@qq.com', 'BaseFunction', 'heatmap');
INSERT INTO `history` VALUES ('1792802452UeEU202105211350143QGh', 'UploadFolder/1792802452@qq.com/', '20210521135014_heatmap.rpkm.txt', 'UserFolder/1792802452@qq.com/', '20210521135014_heatmap.svg', '1792802452@qq.com', 'BaseFunction', 'heatmap');
INSERT INTO `history` VALUES ('1792802452uLIc20210521135924ex1h', 'UploadFolder/1792802452@qq.com/', '20210521135924_heatmap.rpkm.txt', 'UserFolder/1792802452@qq.com/', '20210521135924_heatmap.svg', '1792802452@qq.com', 'BaseFunction', 'heatmap');
INSERT INTO `history` VALUES ('1792802452x25d20210521140009Ef7b', 'UploadFolder/1792802452@qq.com/', '20210521140009_heatmap.rpkm.txt', 'UserFolder/1792802452@qq.com/', '20210521140009_heatmap.svg', '1792802452@qq.com', 'BaseFunction', 'heatmap');
INSERT INTO `history` VALUES ('1792802452xYu020210521134439x7FE', 'UploadFolder/1792802452@qq.com/', '20210521134439_heatmap.rpkm.txt', 'UserFolder/1792802452@qq.com/', '20210521134439_heatmap.svg', '1792802452@qq.com', 'BaseFunction', 'heatmap');

-- ----------------------------
-- Table structure for informationsheet
-- ----------------------------
DROP TABLE IF EXISTS `informationsheet`;
CREATE TABLE `informationsheet`  (
  `ORDERNO` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '单号 系统生成',
  `NAME` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '姓名',
  `WORKUNIT` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '单位',
  `TELEPHONE` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '手机号',
  `SHUNFENGNO` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '顺丰号',
  `WECHAT` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '微信号',
  `STATE` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '状态： 完成/未完成  completed/uncompleted',
  `TIME` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '时间：年月日小时',
  `RESPONSIBLEMAN` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '负责人',
  `ISFREE` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '是否收费',
  PRIMARY KEY (`ORDERNO`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of informationsheet
-- ----------------------------

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `EMAIL` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `NAME` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `PASSWORD` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `TELEPHONE` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `ROLE` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`EMAIL`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES ('001@qq.com', NULL, '$2a$10$RTh/TurpWANr6PVVGwB2ReObnzND.vx6Bj.3ujLf12Qx31vMNwmXi', '123456', 'ROLE_ADMIN');
INSERT INTO `user` VALUES ('002@qq.com', NULL, '$2a$10$Bi8il04A/oxd56ME3kgNPeWEAI4P98OJg9qBwGgVyT2wUcv97Kyc6', '123456', 'ROLE_USER');
INSERT INTO `user` VALUES ('17531865118@163.com', NULL, '$2a$10$TvJ8q3Vv8YSQZhedYxS5JOR4Rk2XDM77R1zFX7zKtBqqFzD9OBjnu', '17531865118', 'ROLE_USER');
INSERT INTO `user` VALUES ('1792802452@qq.com', NULL, '$2a$10$DiCBFOw2tzDdZwCDwDxyAO0Ueeg7iTxMt56vpHAdVpY15WF6EbzyK', '18800000000', 'ROLE_USER');
INSERT INTO `user` VALUES ('947638760@qq.com', NULL, '$2a$10$HUymksdPvjrSpNmo4Fz2BOaD71sDthao2yR6RXIfqJVCRwzamp4CC', '18811636908', 'ROLE_USER');

SET FOREIGN_KEY_CHECKS = 1;
