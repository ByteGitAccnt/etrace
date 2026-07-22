/*
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : .55,
      child: Card(
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: emeraldLight.withOpacity(.15),
                  child: Icon(icon, color: emeraldDark),
                ),

                const SizedBox(width: 18),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        subtitle,
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),

                enabled
                    ? const Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: emeraldDark,
                      )
                    : Chip(
                        label: const Text("Soon"),
                        backgroundColor: Colors.grey.shade200,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }*/
  /*
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : .55,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(18),
          splashColor: emeraldLight.withOpacity(.25),
          highlightColor: emeraldLight.withOpacity(.12),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: emeraldLight.withOpacity(.15),
                  child: Icon(icon, color: emeraldDark),
                ),

                const SizedBox(width: 18),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),

                enabled
                    ? const Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: emeraldDark,
                      )
                    : Chip(
                        label: const Text("Soon"),
                        backgroundColor: Colors.grey.shade200,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }*/