import 'package:flutter/material.dart';

class CardData {
  final String title;
  final String content;
  final IconData icon;

  const CardData({
    required this.title,
    required this.content,
    required this.icon,
  });
}

class DiagramItem {
  final String label;
  final String description;
  final Color color;

  const DiagramItem({
    required this.label,
    required this.description,
    required this.color,
  });
}

class CodeExample {
  final String title;
  final String code;
  final String explanation;

  const CodeExample({
    required this.title,
    required this.code,
    required this.explanation,
  });
}

class TopicModel {
  final String title;
  final String shortTitle;
  final String description;
  final String level;
  final IconData icon;
  final Color primaryColor;
  final Color secondaryColor;
  final List<CardData> cards;
  final List<DiagramItem> diagramItems;
  final CodeExample example;

  const TopicModel({
    required this.title,
    required this.shortTitle,
    required this.description,
    required this.level,
    required this.icon,
    required this.primaryColor,
    required this.secondaryColor,
    required this.cards,
    required this.diagramItems,
    required this.example,
  });
}